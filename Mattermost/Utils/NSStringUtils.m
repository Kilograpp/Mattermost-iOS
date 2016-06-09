//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "NSStringUtils.h"


@implementation NSStringUtils

+ (BOOL)isStringEmpty:(NSString*)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }

    return ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];

}
@end