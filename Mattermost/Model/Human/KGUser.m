#import "KGUser.h"
#import "KGTeam.h"
#import "KGChannel.h"
#import "KGBusinessLogic.h"
#import "KGObjectManager.h"
#import "KGBusinessLogic+Session.h"
#import "NSStringUtils.h"
#import "KGUtils.h"
#import "KGTheme.h"
#import <RestKit.h>
#import "KGUserStatus.h"
#import "KGUserStatusObserver.h"
#import "UIFont+KGPreparedFont.h"

static NSString * const kAwayNetworkString = @"away";
static NSString * const kOnlineNetworkString = @"online";
static NSString * const kOfflineNetworkString = @"offline";

@interface KGUser ()

// Private interface goes here.

@end

@implementation KGUser

#pragma mark - Properties

- (NSURL*)imageUrl {
    return [[KGBusinessLogic sharedInstance] imageUrlForUser:self];
}

- (KGUserNetworkStatus)networkStatus {
    KGUserStatus *status = [[KGUserStatusObserver sharedObserver] userStatusForIdentifier:self.identifier];
    SWITCH(status.backendStatus) {
        CASE(kOnlineNetworkString) {
            return KGUserOnlineStatus;
        }
        CASE(kAwayNetworkString) {
            return KGUserAwayStatus;
        }
        CASE(kOfflineNetworkString) {
            return KGUserOfflineStatus;
        }
        DEFAULT {
            return KGUserUnknownStatus;
        };
    }
}


#pragma mark - Mappings

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"first_name" : [KGUserAttributes firstName],
            @"last_name"  : [KGUserAttributes lastName]
    }];
    [mapping addAttributeMappingsFromArray:@[[KGUserAttributes username], [KGUserAttributes email], [KGUserAttributes nickname]]];
    return mapping;
}

+ (RKEntityMapping*)directProfileEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setForceCollectionMapping:YES];
    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
    [mapping addAttributeMappingsFromDictionary:@{
            @"(identifier).first_name" : @"firstName",
            @"(identifier).last_name"  : @"lastName",
            @"(identifier).username"   : @"username",
            @"(identifier).email"      : @"email"
    }];
    return mapping;
}


//+ (RKEntityMapping*)statusEntityMapping {
//    RKEntityMapping *mapping = [super emptyEntityMapping];
//    [mapping setForceCollectionMapping:YES];
//    [mapping setIdentificationAttributes:@[@"identifier"]];
//    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
//    [mapping addAttributeMappingsFromDictionary:@{
//            @"(identifier)" : @"backendStatus"
//    }];
//    return mapping;
//}



#pragma mark - Path Patterns

+ (NSString*)authPathPattern {
    return @"users/login";
}

+ (NSString*)initialLoadPathPattern {
    return [KGTeam initialLoadPathPattern];
}

+ (NSString*)channelMembersListPathPattern {
    return [KGChannel listPathPattern];
}

+ (NSString*)avatarPathPattern {
    return @"users/:identifier/image";
}

+ (NSString*)attachDevicePathPattern {
    return @"users/attach_device";
}

+ (NSString*)uploadAvatarPathPattern {
    return @"users/newimage";
}

+ (NSString*)usersStatusPathPattern {
    return @"users/status";
}

+ (NSString*)logoutPathPattern {
    return @"users/logout";
}

+ (NSString*)socketPathPattern {
    return @"users/websocket";
}

+ (NSString *)fullUsersListPathPattern {
    return @"users/profiles_for_dm_list/:identifier";
}

#pragma mark - Response Descriptors

+ (RKResponseDescriptor*)authResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self authPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


+ (RKResponseDescriptor*)attachDeviceResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self attachDevicePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)logoutResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self logoutPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


+ (RKResponseDescriptor*)initialLoadResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self directProfileEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self initialLoadPathPattern]
                                                       keyPath:@"direct_profiles"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)themeResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[KGTheme mapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self authPathPattern]
                                                       keyPath:@"theme_props"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)fullUsersListResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[KGUser entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self fullUsersListPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)uploadAvatarResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self uploadAvatarPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

//+ (RKResponseDescriptor*)channelMembersListResponseDescriptor {
//    return [RKResponseDescriptor responseDescriptorWithMapping:[self directProfileEntityMapping]
//                                                        method:RKRequestMethodGET
//                                                   pathPattern:[self channelMembersListPathPattern]
//                                                       keyPath:@"members"
//                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//}

+ (RKResponseDescriptor*)statusResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[KGUserStatus objectMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self usersStatusPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


#pragma mark - Core Data

- (void)willSave {
    if ([NSStringUtils isStringEmpty:self.nickname] && ![NSStringUtils isStringEmpty:self.username]) {
        self.nickname = self.username;
        self.nicknameWidthValue = [NSStringUtils widthOfString:self.nickname withFont:[UIFont kg_semibold16Font]];
    }
}


#pragma mark - Public

- (NSString *)stringFromNetworkStatus {
    switch (self.networkStatus) {
        case KGUserOnlineStatus:{
            return @"online";
        }
        case KGUserAwayStatus:{
            return @"away";
        }
        case KGUserOfflineStatus: {
            return @"offline";
        }
        case KGUserUnknownStatus: {
            return @"updating";
        }
    }
}

@end
