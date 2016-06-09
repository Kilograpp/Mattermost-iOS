#import "KGChannel.h"
#import <RestKit.h>
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Team.h"
#import "KGTeam.h"

@interface KGChannel ()

@end

@implementation KGChannel

#pragma mark - Mappings

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"type"            : @"backendType",
            @"team_id"         : @"teamId",
            @"create_at"       : @"createdAt",
            @"update_at"       : @"updatedAt",
            @"display_name"    : @"displayName",
            @"last_post_at"    : @"lastPostDate",
            @"total_msg_count" : @"messagesCount",
            @"extra_update_at" : @"shouldUpdateAt"
    }];
    [mapping addAttributeMappingsFromArray:@[@"name", @"purpose", @"header"]];
    [mapping addConnectionForRelationship:@"team" connectedBy:@{@"teamId" : @"identifier"}];

    return mapping;
}

#pragma mark - Path Patterns

+ (NSString*)listPathPattern {
    return @"teams/:identifier/channels/";
}

#pragma mark - Response Descriptors

+ (RKResponseDescriptor*)channelsListResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self listPathPattern]
                                                       keyPath:@"channels"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


#pragma mark - Core Data

- (void)willSave{
    [super willSave];

    if (!self.team) {
        self.team = [[KGBusinessLogic sharedInstance] currentTeamInContext:self.managedObjectContext];
    }
}

@end
