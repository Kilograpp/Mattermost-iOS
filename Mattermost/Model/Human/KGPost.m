#import "KGPost.h"
#import <RestKit.h>

@interface KGPost ()

@end

@implementation KGPost

+ (RKEntityMapping*)entityMapping {
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

+ (NSString*)postsPathPattern {
    return @"teams/:team.identifier/channels/:identifier/posts/page/:page/:size";
}

+ (RKResponseDescriptor*)postsResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self postsPathPattern]
                                                       keyPath:@"posts"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


@end
