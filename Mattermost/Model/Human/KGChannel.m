#import "KGChannel.h"
#import <RestKit.h>
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Team.h"
#import "KGTeam.h"
#import "KGUser.h"
#import "KGUtils.h"
#import "NSStringUtils.h"
#import "KGBusinessLogic+Session.h"
#import "KGBusinessLogic+Channel.h"
#import "DateTools.h"

@interface KGChannel ()

@end

@implementation KGChannel

#pragma mark - Properties

- (BOOL)hasNewMessages {
    return [self.lastViewDate isEarlierThan:self.lastPostDate];
}

- (KGChannelType)type {
    SWITCH(self.backendType) {
        CASE(@"D")
            return KGChannelTypePrivate;
        CASE(@"O")
            return KGChannelTypePublic;
        DEFAULT
            return KGChannelTypeUnknown;
    }
}

- (NSString*)notificationsName {
    return [[KGBusinessLogic sharedInstance] notificationNameForChannel:self];
}

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
            @"extra_update_at" : @"lastViewDate"
    }];
    [mapping addAttributeMappingsFromArray:@[@"name", @"purpose", @"header"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"members" mapping:[KGUser entityMapping]];
    [mapping addConnectionForRelationship:@"team" connectedBy:@{@"teamId" : @"identifier"}];

    return mapping;
}



#pragma mark - Path Patterns

+ (NSString*)listPathPattern {
    return @"teams/:identifier/channels/";
}

+ (NSString*)extraInfoPathPattern {
    return @"teams/:team.identifier/channels/:identifier/extra_info";
}

+ (NSString*)updateLastViewDatePathPattern {
    return @"teams/:team.identifier/channels/:identifier/update_last_viewed_at";
}

#pragma mark - Response Descriptors

+ (RKResponseDescriptor*)channelsListResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self listPathPattern]
                                                       keyPath:@"channels"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


+ (RKResponseDescriptor*)extraInfoResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self extraInfoPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)updateLastViewDataResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self updateLastViewDatePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}



#pragma mark - Core Data

- (void)willSave {
    [super willSave];
    [self configureTeam];
    [self configureDisplayName];
}

#pragma mark - Support

- (void)configureTeam {
    if (!self.team) {
        self.team = [[KGBusinessLogic sharedInstance] currentTeamInContext:self.managedObjectContext];
    }
}

- (void)configureDisplayName {
    if (self.type == KGChannelTypePrivate && [NSStringUtils isStringEmpty:self.displayName]) {
        NSArray *sideIds = [self.name componentsSeparatedByString:@"__"];
        NSString *companionIdentifier;

        if (![sideIds.firstObject isEqualToString:[KGBusinessLogic sharedInstance].currentUserId]) {
            companionIdentifier = sideIds.firstObject;
        } else {
            companionIdentifier = sideIds.lastObject;
        }

        NSString *futureName = [[KGUser managedObjectById:companionIdentifier inContext:self.managedObjectContext] username];
        self.displayName = futureName;
    }
}

- (KGUserNetworkStatus)configureNetworkStatus {
    KGUserNetworkStatus userNetworkStatus;
    if (self.type == KGChannelTypePrivate) {
        NSArray *sideIds = [self.name componentsSeparatedByString:@"__"];
        NSString *companionIdentifier;
        companionIdentifier = (![sideIds.firstObject isEqualToString:[KGBusinessLogic sharedInstance].currentUserId]) ? sideIds.firstObject : sideIds.lastObject;
        KGUser *user = [KGUser managedObjectById:companionIdentifier];
        userNetworkStatus = [user networkStatus];
    }
    return userNetworkStatus;
}


#pragma mark - Public

+ (NSString *)titleForChannelBackendType:(NSString *)backendType {

    SWITCH(backendType) {
        CASE(@"D")
            return @"Private messages";
        CASE(@"O")
            return @"Channels";
        DEFAULT
            return @"Unknown";
    }
}

@end
