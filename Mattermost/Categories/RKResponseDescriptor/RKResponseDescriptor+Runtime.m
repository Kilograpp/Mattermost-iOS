//
//  RKResponseDescriptor+Runtime.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "RKResponseDescriptor+Runtime.h"
#import "NSObject+RuntimeMethodsValues.h"
#import "KGManagedObject.h"

extern NSString * const KGRestKitClassPrefix;

@implementation RKResponseDescriptor (Runtime)

+ (NSArray*) findAllDescriptors {
    return [self dumpValuesFromRootClass:[KGManagedObject class] withClassPrefix:KGRestKitClassPrefix];
}

@end
