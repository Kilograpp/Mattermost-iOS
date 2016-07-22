//
//  RKRequestDescriptor+Runtime.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "RKRequestDescriptor+Runtime.h"
#import "KGManagedObject.h"
#import "NSObject+RuntimeMethodsValues.h"

extern NSString * const KGRestKitClassPrefix;

@implementation RKRequestDescriptor (Runtime)

+ (NSArray*) findAllDescriptors {
    return [self dumpValuesFromRootClass:[KGManagedObject class] withClassPrefix:KGRestKitClassPrefix];
}

@end
