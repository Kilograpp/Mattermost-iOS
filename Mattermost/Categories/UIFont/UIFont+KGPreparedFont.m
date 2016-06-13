//
//  UIFont+KGPreparedFont.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIFont+KGPreparedFont.h"
#import "KGUtils.h"

static NSString *const KGPreparedFontsRegularFontName            = @"SFUIText-Regular";
static NSString *const KGPreparedFontsSemiboldFontName           = @"SFUIText-Semibold";
static NSString *const KGPreparedFontsMediumFontName             = @"SFUIText-Medium";
static NSString *const KGPreparedFontsBoldFontName               = @"SFUIText-Bold";

static NSString *const KGPreparedFontsRegularDisplayFontName     = @"SFUIDisplay-Regular";
static NSString *const KGPreparedFontsSemiboldDisplayFontName    = @"SFUIDisplay-Semibold";
static NSString *const KGPreparedFontsBoldDisplayFontName        = @"SFUIDisplay-Bold";
static NSString *const KGPreparedFontsMediumDisplayFontName      = @"SFUIDisplay-Medium";

@implementation UIFont (CustomFonts)


#pragma mark - Bold


+ (UIFont *)kg_bold28Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldDisplayFontName size:28.f])
    return font;
}

+ (UIFont *)kg_bold16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsBoldDisplayFontName size:16.f])
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


#pragma mark - Navigation Bar

+ (UIFont *)kg_navigationBarTitleFont {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsSemiboldDisplayFontName size:16.f])
    return font;
}

+ (UIFont *)kg_navigationBarSubtitleFont {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedFontsRegularDisplayFontName size:13.f])
    return font;
}

@end

