#import "KGChannel.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Team.h"
#import "KGTeam.h"
#import <RestKit.h>
@interface KGChannel ()

@end

@implementation KGChannel

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"display_name" : @"displayName",
            @"type" : @"backendType",
            @"extra_update_at" : @"shouldUpdateAt",
            @"last_post_at" : @"lastPostDate",
            @"create_at" : @"createdAt",
            @"update_at" : @"updatedAt",
            @"total_msg_count" : @"messagesCount",
            @"team_id" : @"teamId"
    }];
    [mapping addAttributeMappingsFromArray:@[@"name", @"purpose", @"header"]];
    [mapping addConnectionForRelationship:@"team" connectedBy:@{@"teamId" : @"identifier"}];

    return mapping;
}


+ (NSString*)listPathPattern {
    return @"teams/:identifier/channels/";
}

+ (RKResponseDescriptor*)channelsListResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self listPathPattern]
                                                       keyPath:@"channels"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


- (void)willSave{
    [super willSave];

    if (!self.team) {
        self.team = [[KGBusinessLogic sharedInstance] currentTeamInContext:self.managedObjectContext];
    }
}

@end
