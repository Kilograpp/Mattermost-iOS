#import <RestKit/RestKit.h>
#import "KGPost.h"
#import "KGUser.h"
#import "KGChannel.h"
#import "KGFile.h"
#import "DateTools.h"
#import "NSStringUtils.h"
#import "KGUIUtils.h"
#import "TSMarkdownParser+Singleton.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "NSDate+DateFormatter.h"
#import <NSStringEmojize/NSString+Emojize.h>
#import "NSCalendar+KGSharedCalendar.h"
#import "KGBusinessLogic+Session.h"
#import "KGExternalFile.h"
#import <MagicalRecord/MagicalRecord.h>

@interface KGPost ()

@end

@implementation KGPost
@dynamic attributedMessage;
@synthesize nonImageFiles = _nonImageFiles;
- (BOOL)isUnread {
    return ![self.createdAt isEarlierThan:self.channel.lastViewDate];
}

#pragma mark - Mappings

+ (RKEntityMapping *)creationEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setIdentificationAttributes:@[@"backendPendingId"]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"pending_post_id" : @"backendPendingId",
            @"id" : @"identifier"
    }];
    return mapping;
}

+ (RKEntityMapping*)listEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setForceCollectionMapping:YES];
    [mapping setAssignsNilForMissingRelationships:NO];
    //FIXME: идентификационный атрибут устанавливатеся в KGManagedObject
    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
    [mapping addAttributeMappingsFromDictionary:@{
            @"(identifier).create_at"  : @"createdAt",
            @"(identifier).update_at"  : @"updatedAt",
            @"(identifier).message"    : @"message",
            @"(identifier).type"       : @"type",
            @"(identifier).user_id"    : @"userId",
            @"(identifier).channel_id" : @"channelId"
    }];
    [mapping addConnectionForRelationship:@"author"  connectedBy:@{@"userId"    : @"identifier"}];
    [mapping addConnectionForRelationship:@"channel" connectedBy:@{@"channelId" : @"identifier"}];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"(identifier).filenames"
                                                                             toKeyPath:@"files"
                                                                           withMapping:[KGFile simpleEntityMapping]]];

    return mapping;
}


+ (RKObjectMapping *)creationRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"message"]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"channel.identifier" : @"channel_id",
            @"author.identifier" : @"user_id",
            @"backendPendingId" : @"pending_post_id",
            @"files.backendLink" : @"filenames"
    }];
//    
//    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"files"
//                                                                            toKeyPath:@"filenames"
//                                                                          withMapping:[KGFile requestMapping]]];

    return mapping;
}

#pragma mark - Path Patterns

+ (NSString*)nextPageListPathPattern {
    return @"teams/:team.identifier/channels/:identifier/posts/:lastPostId/before/:page/:size";
}

+ (NSString*)firstPagePathPattern {
    return @"teams/:team.identifier/channels/:identifier/posts/page/:page/:size";
}

+ (NSString*)updatePathPattern {
    return @"teams/:channel.team.identifier/posts/:identifier";
}


+ (NSString*)creationPathPattern {
    return @"teams/:channel.team.identifier/channels/:channel.identifier/posts/create";
}

#pragma mark - Response Descriptors

+ (RKResponseDescriptor*)listResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self listEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self firstPagePathPattern]
                                                       keyPath:@"posts"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)nextPageResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self listEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self nextPageListPathPattern]
                                                       keyPath:@"posts"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)creationResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self creationEntityMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self creationPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)updateResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self listEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self updatePathPattern]
                                                       keyPath:@"posts"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


#pragma mark - Core Data

- (void)awakeFromFetch {
    [super awakeFromFetch];
    
    [self configureDiplayDate];
}

- (void)configureDiplayDate {
    if (!self.creationDay && self.createdAt) {
        unsigned int      intFlags   = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSCalendar       *calendar   = [NSCalendar kg_sharedGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        components = [calendar components:intFlags fromDate:self.createdAt];
        
        self.creationDay = [calendar dateFromComponents:components];
    }
}

- (NSArray *)sortedFiles {
    NSSortDescriptor *isImageSortDesctiptor =
            [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(isImage)) ascending:YES];
    NSSortDescriptor *nameSortDesctiptor =
            [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
    NSArray *sortDesctiptors = @[ isImageSortDesctiptor, nameSortDesctiptor ];
    return [self.files.allObjects sortedArrayUsingDescriptors:sortDesctiptors];
}

- (NSArray *)nonImageFiles {
    if (!_nonImageFiles) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isImage == %@", @NO];
        NSSet *set = [self.files filteredSetUsingPredicate:predicate];
        NSSortDescriptor *nameSortDesctiptor =
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
        
        _nonImageFiles = [set.allObjects sortedArrayUsingDescriptors:@[ nameSortDesctiptor ]];
    }

    return _nonImageFiles;
}

#pragma mark - Request Descriptors

+ (RKRequestDescriptor*)createRequestDescriptor {
    return [RKRequestDescriptor requestDescriptorWithMapping:[self creationRequestMapping]
                                                 objectClass:self
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodPOST];
}


#pragma mark - Public

bool postsHaveSameAuthor(KGPost *post1, KGPost *post2) {
    return [post1.author.identifier isEqualToString:post2.author.identifier];
}

- (NSTimeInterval)timeIntervalSincePost:(KGPost *)post {
    return [self.createdAt timeIntervalSinceDate:post.createdAt];
}

- (BOOL)hasAttachments {
    return self.files.count;
}

- (void)configureBackendPendingId {
    [self setBackendPendingId:
     [NSString stringWithFormat:@"%@:%lf",[[KGBusinessLogic sharedInstance] currentUserId],
      [self.createdAt timeIntervalSince1970]]];
}

#pragma mark - Core Data


//- (void)willSave {
//    if ([self isMessageUnprocessed]) {
//        [self replaceEmojiWithUnicode];
//        [self parseMarkdown];
//        [self parseImagesFromMessageLinks];
//        [self saveCreatedAtDateAsString];
//        [self calculateMessageWidth];
//        [self calculateMessageHeight];
//    } else {
//        if ([self isMissingInlineImages]) {
//            [self parseImagesFromMessageLinks];
//        }
//    }
//    [super willSave];
//}
//
#pragma mark - Configuration Support

- (BOOL)isMessageUnprocessed {
    return ![NSStringUtils isStringEmpty:self.message] && !self.attributedMessage;
}

- (void)saveCreatedAtDateAsString {
    self.createdAtString = [self.createdAt timeFormatForMessages];
}

- (void)parseMarkdown {
    self.attributedMessage = [[TSMarkdownParser sharedInstance] attributedStringFromMarkdown:self.message];
}


- (void)replaceEmojiWithUnicode {
    self.message = [self.message emojizedString];
}

- (void)calculateCreateAtWidth {
    self.createdAtWidthValue = [NSStringUtils widthOfString:self.createdAtString withFont:[UIFont kg_regular13Font]];
}

- (void)calculateMessageHeight {
    CGFloat textWidth = KGScreenWidth() - 88;
    CGRect frame = [self.attributedMessage boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        context:nil];
    self.height =  @(ceilf(frame.size.height));
}

- (BOOL)isMissingInlineImages {
    return !self.files.count && self.shouldCheckForMissingFilesValue && self.attributedMessage;
}

- (void)setCreatedAt:(NSDate *)createdAt {
    [self willChangeValueForKey:[KGPostAttributes createdAt]];
    [self setPrimitiveCreatedAt:createdAt];
    [self didChangeValueForKey:[KGPostAttributes createdAt]];
    [self saveCreatedAtDateAsString];
    [self calculateCreateAtWidth];
}

- (void)setMessage:(NSString *)message {
    [self willChangeValueForKey:[KGPostAttributes message]];
    [self setPrimitiveMessage:[message emojizedString]];
    [self parseMarkdown];
    [self parseImagesFromMessageLinks];
    [self calculateMessageHeight];
    [self didChangeValueForKey:[KGPostAttributes message]];
}

- (void)parseImagesFromMessageLinks {

    [self.attributedMessage enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, self.attributedMessage.length) options:0 usingBlock:^(NSURL*  _Nullable link, NSRange range, BOOL * _Nonnull stop) {
        if ([link.pathExtension.lowercaseString isEqualToString:@"jpg"] ||
            [link.pathExtension.lowercaseString isEqualToString:@"png"] ||
            [link.pathExtension.lowercaseString isEqualToString:@"jpeg"]) {
            
            KGExternalFile* file = [KGExternalFile MR_createEntityInContext:self.managedObjectContext];
            [file setLink:link.absoluteString];
            [self addFilesObject:file];

            [self setPrimitiveShouldCheckForMissingFilesValue:YES];
        }
    }];
}

@end
