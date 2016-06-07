//
// Created by Maxim Gubin on 07/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "NSError+KGError.h"
#import "KGError.h"
#import <RestKit.h>

@implementation NSError (KGError)

- (KGError *)kg_error {
    return [[self userInfo][RKObjectMapperErrorObjectsKey] firstObject];
}

@end
