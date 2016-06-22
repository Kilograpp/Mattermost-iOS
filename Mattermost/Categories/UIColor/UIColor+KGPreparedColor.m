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

#pragma mark - Left Menu
+ (UIColor *)kg_sectionColorLeftMenu {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#C3CDD4" alpha:1])
    return color;
}

+ (UIColor *)kg_leftMenuBackgroundColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#2071A8" alpha:1])
    return color;
}

+ (UIColor *)kg_leftMenuHighlightColor {
    STATIC_ONCE(color, [UIColor colorWithRed:54/255.f green:127/255.f blue:176/255.f alpha:1.f])
    return color;
}

+ (UIColor *)kg_leftMenuHeaderColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#2F81B7" alpha:1])
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

+ (UIColor *)kg_rightMenuSeparatorColor {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#8798A4" alpha:1])
    return color;
}


#pragma mark - Gradient

+ (UIColor *)kg_topBlueColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#1D66DE" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomBlueColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#248BE2" alpha:1])
    return color;
}

+ (UIColor *)kg_topRedColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#9F041B" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomRedColorForGradient{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#F5515F" alpha:1])
    return color;
}

+ (UIColor *)kg_topGreenColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#429321" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomGreenColorForGradient{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#B4EC51" alpha:1])
    return color;
}

+ (UIColor *)kg_topOrangeColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#F76B1C" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomOrangeColorForGradient{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#FAD961" alpha:1])
    return color;
}

+ (UIColor *)kg_topPurpleColorForGradient {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#3023AE" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomPurpleColorForGradient{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#C86DD7" alpha:1])
    return color;
}

#pragma mark - Gradient Alert

+ (UIColor *)kg_topRedColorForAlert {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#CF2F41" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomRedColorForAlert{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#F5515F" alpha:1])
    return color;
}

+ (UIColor *)kg_topYellowColorForAlert {
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#F9BD4F" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomYellowColorForAlert{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#FAD961" alpha:1])
    return color;
}

+ (UIColor *)kg_topGreenColorForAlert{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#429321" alpha:1])
    return color;
}

+ (UIColor *)kg_bottomGreenColorForAlert{
    STATIC_ONCE(color, [UIColor hx_colorWithHexRGBAString:@"#6CB433" alpha:1])
    return color;
}



@end
