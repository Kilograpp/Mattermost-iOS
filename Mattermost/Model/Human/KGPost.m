#import "KGPost.h"
#import "KGUser.h"
#import "KGChannel.h"
#import "KGFile.h"
#import "DateTools.h"
#import <RestKit.h>

@interface KGPost ()

@end

@implementation KGPost

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

+ (NSString*)listPathPattern {
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
                                                   pathPattern:[self listPathPattern]
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


#pragma mark - Request Descriptors

+ (RKRequestDescriptor*)createRequestDescriptor {
    return [RKRequestDescriptor requestDescriptorWithMapping:[self creationRequestMapping]
                                                 objectClass:self
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodPOST];
}


#pragma mark - Public Getters



@end
