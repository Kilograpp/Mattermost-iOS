//
//  UIColor+KGPreparedColor.h
//  Mattermost
//
//  Created by Tatiana on 03/06/16.
//  Copyright © 2016 Tatiana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KGPreparedColor)

#pragma mark - Common

+ (UIColor *)kg_blueColor;
+ (UIColor *)kg_whiteColor;
+ (UIColor *)kg_blackColor;
+ (UIColor *)kg_grayColor;
+ (UIColor *)kg_lightGrayColor;
+ (UIColor *)kg_redColor;
+ (UIColor *)kg_lightBlueColor;
+ (UIColor *)kg_lightLightGrayColor;

+ (UIColor *)kg_disabledButtonTintColor;
+ (UIColor *)kg_enabledButtonTintColor;

+ (UIColor *)kg_rightMenuSeparatorColor;

+ (UIColor *)kg_autocompletionViewBackgroundColor;

+ (UIColor *)kg_navigationBarTintColor;

#pragma mark - Left menu

+ (UIColor *)kg_leftMenuBackgroundColor;
+ (UIColor *)kg_leftMenuHighlightColor;
+ (UIColor *)kg_leftMenuHeaderColor;
+ (UIColor *)kg_sectionColorLeftMenu;
+ (UIColor *)kg_yellowColor;
+ (UIColor *)kg_greenColor;

#pragma mark - Login

+ (UIColor *)kg_loginSubtitleColor;

#pragma mark - Gradient

+ (UIColor *)kg_topBlueColorForGradient;
+ (UIColor *)kg_bottomBlueColorForGradient;
+ (UIColor *)kg_topRedColorForGradient;
+ (UIColor *)kg_bottomRedColorForGradient;
+ (UIColor *)kg_topGreenColorForGradient;
+ (UIColor *)kg_bottomGreenColorForGradient;
+ (UIColor *)kg_topOrangeColorForGradient;
+ (UIColor *)kg_bottomOrangeColorForGradient;
+ (UIColor *)kg_topPurpleColorForGradient;
+ (UIColor *)kg_bottomPurpleColorForGradient;

#pragma mark - Gradient Alert

+ (UIColor *)kg_redColorForAlert;
+ (UIColor *)kg_yellowColorForAlert;
+ (UIColor *)kg_greenColorForAlert;

@end
