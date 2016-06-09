#import "KGPost.h"
#import "KGUser.h"
#import "KGChannel.h"
#import <RestKit.h>

@interface KGPost ()

@end

@implementation KGPost

#pragma mark - Mappings

+ (RKEntityMapping*)listEntityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setForceCollectionMapping:YES];
    [mapping setAssignsNilForMissingRelationships:NO];
    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
    [mapping addAttributeMappingsFromDictionary:@{
            @"(identifier).create_at" : @"createdAt",
            @"(identifier).update_at" : @"updatedAt",
            @"(identifier).message"   : @"message",
            @"(identifier).type"      : @"type",
            @"(identifier).userId"    : @"userId"
    }];
    [mapping addConnectionForRelationship:@"author"  connectedBy:@{@"userId"    : @"identifier"}];
    [mapping addConnectionForRelationship:@"channel" connectedBy:@{@"channelId" : @"identifier"}];
    return mapping;
}


+ (RKObjectMapping *)creationRequestMapping {
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"message"]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"channel.identifier" : @"channel_id",
            @"author.identifier" : @"user_id"
    }];

    return mapping;
}

#pragma mark - Path Patterns

+ (NSString*)listPathPattern {
    return @"teams/:team.identifier/channels/:identifier/posts/page/:page/:size";
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
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self creationPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

#pragma mark - Request Descriptors

+ (RKRequestDescriptor*)createRequestDescriptor {
    return [RKRequestDescriptor requestDescriptorWithMapping:[self creationRequestMapping]
                                                 objectClass:self
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodPOST];
}

@end
