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

+ (NSString*)randomAlphanumericStringWithLength:(NSUInteger) length {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomString;
}

+(NSString *)randomUUID
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);

    return uuidString;
}

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    return ceilf([string sizeWithAttributes:attributes].width);
}


@end