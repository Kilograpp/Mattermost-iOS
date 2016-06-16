#import "KGUser.h"
#import "KGTeam.h"
#import "KGChannel.h"
#import "KGBusinessLogic.h"
#import "KGObjectManager.h"
#import "KGBusinessLogic+Session.h"
#import "NSStringUtils.h"
#import "KGUtils.h"
#import <RestKit.h>

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
    SWITCH(self.backendStatus) {
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
            return KGUserOfflineStatus;
        };
    }
}


#pragma mark - Mappings

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"first_name" : @"firstName",
            @"last_name"  : @"lastName"
    }];
    [mapping addAttributeMappingsFromArray:@[@"username", @"email", @"nickname"]];
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

+ (RKEntityMapping*)statusEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setForceCollectionMapping:YES];
    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
    [mapping addAttributeMappingsFromDictionary:@{
            @"(identifier)" : @"backendStatus"
    }];
    return mapping;
}



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


+ (RKResponseDescriptor*)initialLoadResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self directProfileEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self initialLoadPathPattern]
                                                       keyPath:@"direct_profiles"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)channelMembersListResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self directProfileEntityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self channelMembersListPathPattern]
                                                       keyPath:@"members"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)statusResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self statusEntityMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self usersStatusPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


#pragma mark - Core Data

- (void)willSave {
    if ([NSStringUtils isStringEmpty:self.nickname] && ![NSStringUtils isStringEmpty:self.username]) {
        self.nickname = self.username;
    }
}




@end
