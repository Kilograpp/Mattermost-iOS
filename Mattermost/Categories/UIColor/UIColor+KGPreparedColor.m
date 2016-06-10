//
//  UIColor+KGPreparedColor.m
//  Mattermost
//
//  Created by Tatiana on 03/06/16.
//  Copyright © 2016 Tatiana. All rights reserved.
//

#import "UIColor+KGPreparedColor.h"
#import "KGUtils.h"

@implementation UIColor (KGPreparedColor)

+ (UIColor *)kg_blueColor {
    STATIC_ONCE(color, [UIColor colorWithRed:35/255.f green:127/255.f blue:215/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_whiteColor {
    STATIC_ONCE(color, [UIColor whiteColor])
    return color;
}

+ (UIColor *)kg_blackColor {
    STATIC_ONCE(color, [UIColor blackColor])
    return color;
}

+ (UIColor *)kg_grayColor {
    STATIC_ONCE(color, [UIColor grayColor])
    return color;
}
+ (UIColor *)kg_lightGrayColor {
    STATIC_ONCE(color, [UIColor lightGrayColor])
    return color;
}
+ (UIColor *)kg_redColor {
    STATIC_ONCE(color, [UIColor colorWithRed:226/255.f green:61/255.f blue:61/255.f alpha:1.f]);
    return color;
}
+ (UIColor *)kg_lightBlueColor {
    STATIC_ONCE(color, [UIColor colorWithRed:189/255.f green:212/255.f blue:288/255.f alpha:1.f])
    return color;
}
@end
