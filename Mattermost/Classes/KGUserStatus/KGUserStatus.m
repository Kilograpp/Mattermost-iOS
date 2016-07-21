//
//  KGUserStatus.m
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGUserStatus.h"
#import <RestKit.h>
#import "KGUtils.h"

@implementation KGUserStatus


+ (RKObjectMapping*)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping setForceCollectionMapping:YES];
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"identifier"];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"(identifier)" : @"backendStatus"
                                                  }];
    return mapping;
}

+ (NSString*)usersStatusPathPattern {
    return @"users/status";
}

+ (RKResponseDescriptor*)statusResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self objectMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self usersStatusPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


@end
