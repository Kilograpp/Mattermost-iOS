//
//  UIColor+KGPreparedColor.m
//  Mattermost
//
//  Created by Tatiana on 03/06/16.
//  Copyright © 2016 Tatiana. All rights reserved.
//

#import "UIColor+KGPreparedColor.h"
#import "KGUtils.h"
#import <HexColors/HexColors.h>

@implementation UIColor (KGPreparedColor)

+ (UIColor *)kg_blueColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#0076FF" alpha:1])
    return color;
}

+ (UIColor *)kg_blackColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#3B3B3B" alpha:1])
    return color;
}

+ (UIColor *)kg_whiteColor {
    STATIC_ONCE(color, [UIColor whiteColor])
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

+ (UIColor *)kg_lightLightGrayColor {
    STATIC_ONCE(color, [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1.f])
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

+ (UIColor *)kg_leftMenuBackgroundColor {
    STATIC_ONCE(color, [UIColor colorWithRed:32/255.f green:113/255.f blue:167/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_leftMenuHighlightColor {
    STATIC_ONCE(color, [UIColor colorWithRed:54/255.f green:127/255.f blue:176/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_leftMenuHeaderColor {
    STATIC_ONCE(color, [UIColor colorWithRed:47/255.f green:129/255.f blue:173/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_loginSubtitleColor {
    STATIC_ONCE(color, [UIColor colorWithRed:51/255.f green:70/255.f blue:89/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_disabledButtonTintColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#ABB4BD" alpha:1])
    return color;
}

+ (UIColor *)kg_enabledButtonTintColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#0076FF" alpha:1])
    return color;
}

@end
