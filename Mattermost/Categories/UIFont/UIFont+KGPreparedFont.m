//
//  UIFont+KGPreparedFont.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIFont+KGPreparedFont.h"
#import "KGUtils.h"

NSString *const KGPreparedFontsRegularFontName            = @"SFUIText-Regular";
NSString *const KGPreparedFontsSemiboldFontName           = @"SFUIText-Semibold";
NSString *const KGPreparedFontsMediumFontName             = @"SFUIText-Medium";
NSString *const KGPreparedFontsBoldFontName               = @"SFUIText-Bold";
NSString *const KGPreparedFontsItalicFontName             = @"SFUIText-LightItalic";

NSString *const KGPreparedFontsRegularDisplayFontName     = @"SFUIDisplay-Regular";
NSString *const KGPreparedFontsSemiboldDisplayFontName    = @"SFUIDisplay-Semibold";
NSString *const KGPreparedFontsBoldDisplayFontName        = @"SFUIDisplay-Bold";
NSString *const KGPreparedFontsMediumDisplayFontName      = @"SFUIDisplay-Medium";

@implementation UIFont (CustomFonts)


#pragma mark - BoldDisplay


+ (UIFont *)kg_bold28Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldDisplayFontName size:28.f])
    return font;
}

+ (UIFont *)kg_bold16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldDisplayFontName size:16.f])
    return font;
}

#pragma mark - BoldText

+ (UIFont *)kg_boldText18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldFontName size:18.f])
    return font;
}

+ (UIFont *)kg_boldText13Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldFontName size:13.f])
    return font;
}

+ (UIFont *)kg_boldText16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldFontName size:16.f])
    return font;
}

+ (UIFont *)kg_boldText10Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldFontName size:10.f])
    return font;
}


#pragma mark - Semobold

+ (UIFont *)kg_semibold30Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsSemiboldFontName size:30.f])
    return font;
}

+ (UIFont *)kg_semibold20Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsSemiboldFontName size:20.f])
    return font;
}

+ (UIFont *)kg_semibold18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsSemiboldFontName size:18.f])
    return font;
}

+ (UIFont *)kg_semibold16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsSemiboldFontName size:16.f])
    return font;
}


#pragma mark - Regular

+ (UIFont *)kg_regular12Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:12.f])
    return font;
}

+ (UIFont *)kg_regular13Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:13.f])
    return font;
}

+ (UIFont *)kg_regular14Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:14.f])
    return font;
}

+ (UIFont *)kg_regular15Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:15.f])
    return font;
}

+ (UIFont *)kg_regular16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:16.f])
    return font;
}

+ (UIFont *)kg_regular18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularFontName size:18.f])
    return font;
}

+ (UIFont *)kg_regular36Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularDisplayFontName size:36.f])
    return font;
}


#pragma mark - Medium

+ (UIFont *)kg_medium18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsMediumFontName size:18.f])
    return font;
}

#pragma mark - Light

+ (UIFont *)kg_light16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsMediumFontName size:16.f])
    return font;
}

#pragma mark - Navigation Bar

+ (UIFont *)kg_navigationBarTitleFont {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldFontName size:16.f])
    return font;
}

+ (UIFont *)kg_navigationBarSubtitleFont {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularDisplayFontName size:13.f])
    return font;
}


#pragma mark - Markdown

+ (UIFont *)kg_semiboldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:KGPreparedFontsSemiboldFontName size:size];
}


+ (UIFont *)kg_italic15Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsItalicFontName size:15])
    return font;
}

@end

