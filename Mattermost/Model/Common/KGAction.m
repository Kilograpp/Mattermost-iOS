//
//  KGAction.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAction.h"
#import <RestKit/RestKit.h>
@implementation KGAction

- (void)execute {
    
}
+ (RKObjectMapping*)mapping {
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"text" : @"message"}];
    return mapping;
}

@end
