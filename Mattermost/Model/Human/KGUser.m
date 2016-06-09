#import "KGUser.h"
#import "KGTeam.h"
#import "KGChannel.h"
#import <RestKit.h>

@interface KGUser ()

// Private interface goes here.

@end

@implementation KGUser

#pragma mark - Mappings

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"first_name" : @"firstName",
            @"last_name"  : @"lastName"
    }];
    [mapping addAttributeMappingsFromArray:@[@"username", @"email"]];
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

+ (NSString*)attachDevicePathPattern {
    return @"users/attach_device";
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

#pragma mark - Request Descriptors




@end
