//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

@import UIKit;

@interface NSStringUtils : NSObject

+ (BOOL)isStringEmpty:(NSString*)string;
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;
+ (NSString*)randomAlphanumericStringWithLength:(NSUInteger) length;
+ (NSString *)randomUUID;

@end