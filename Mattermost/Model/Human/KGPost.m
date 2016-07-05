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
#import <NSStringEmojize/NSString+Emojize.h>

@interface KGPost ()

@end

@implementation KGPost
@dynamic attributedMessage;
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
        NSCalendar       *calendar   = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        components = [calendar components:intFlags fromDate:self.createdAt];
        
        self.creationDay = [calendar dateFromComponents:components];
    }
}

- (NSArray *)sortedFiles {
    NSSortDescriptor *isImageSortDesctiptor =
            [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(isImage)) ascending:YES];
    NSSortDescriptor *idSortDesctiptor =
            [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES];
    NSArray *sortDesctiptors = @[ isImageSortDesctiptor, idSortDesctiptor ];
    return [[self.files allObjects] sortedArrayUsingDescriptors:sortDesctiptors];
}

#pragma mark - Request Descriptors

+ (RKRequestDescriptor*)createRequestDescriptor {
    return [RKRequestDescriptor requestDescriptorWithMapping:[self creationRequestMapping]
                                                 objectClass:self
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodPOST];
}


#pragma mark - Public Getters

#pragma mark - Core Data


- (void)willSave {
    if (![NSStringUtils isStringEmpty:self.message] && !self.attributedMessage) {
        [TSMarkdownParser sharedInstance].skipLinkAttribute = YES;
        self.message = [self.message emojizedString];
        NSMutableAttributedString *string = [[TSMarkdownParser sharedInstance] attributedStringFromMarkdown:self.message].mutableCopy;
        [string beginEditing];
        __block BOOL found = NO;
        [string enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, string.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                UIFont *newFont = [UIFont kg_regular15Font];
                [string removeAttribute:NSFontAttributeName range:range];
                [string addAttribute:NSFontAttributeName value:newFont range:range];
                found = YES;
            }
        }];
        if (!found) {
            // No font was found - do something else?
        }
        self.attributedMessage = string.copy;
        [string endEditing];
        CGFloat textWidth = KGScreenWidth() - 61.f;      
        CGRect frame = [self.attributedMessage boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                            context:nil];
        self.height =  @(ceilf(frame.size.height));
    }
}

@end
