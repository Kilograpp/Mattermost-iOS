//
//  UIFont+KGPreparedFont.h
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const KGPreparedFontsRegularFontName;            
extern NSString *const KGPreparedFontsSemiboldFontName;         
extern NSString *const KGPreparedFontsMediumFontName;            
extern NSString *const KGPreparedFontsBoldFontName;
extern NSString *const KGPreparedFontsItalicFontName;

extern NSString *const KGPreparedFontsRegularDisplayFontName;     
extern NSString *const KGPreparedFontsSemiboldDisplayFontName ;   
extern NSString *const KGPreparedFontsBoldDisplayFontName ;       
extern NSString *const KGPreparedFontsMediumDisplayFontName ;     

@interface UIFont (KGPreparedFont)

+ (UIFont *)kg_bold16Font;
+ (UIFont *)kg_bold28Font;

+ (UIFont *)kg_boldText10Font;
+ (UIFont *)kg_boldText13Font;
+ (UIFont *)kg_boldText16Font;
+ (UIFont *)kg_boldText18Font;

+ (UIFont *)kg_semibold16Font;
+ (UIFont *)kg_semibold18Font;
+ (UIFont *)kg_semibold20Font;
+ (UIFont *)kg_semibold30Font;

+ (UIFont *)kg_regular13Font;
+ (UIFont *)kg_regular14Font;
+ (UIFont *)kg_regular15Font;
+ (UIFont *)kg_regular16Font;
+ (UIFont *)kg_regular18Font;
+ (UIFont *)kg_regular36Font;

+ (UIFont *)kg_light16Font;
+ (UIFont *)kg_light18Font;

+ (UIFont *)kg_medium18Font;
+ (UIFont *)kg_medium16Font;

+ (UIFont *)kg_navigationBarSubtitleFont;
+ (UIFont *)kg_navigationBarTitleFont;


+ (UIFont *)kg_semiboldFontOfSize:(CGFloat)size;

+ (UIFont *)kg_italic15Font;

@end
