//
//  UIFont+KGPreparedFont.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIFont+KGPreparedFont.h"
#import "KGUtils.h"

NSString *const KGPreparedRegularFontName = @"OpenSans";
NSString *const KGPreparedBoldFontName = @"OpenSans-Bold";
NSString *const KGPreparedSemiboldFontName = @"OpenSans-Semibold";
NSString *const KGPreparedLightFontName = @"OpenSans-Light";

@implementation UIFont (CustomFonts)


#pragma mark - Bold


#pragma mark - Semobold

+ (UIFont *)kg_semibold30Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedSemiboldFontName size:30.f])
    return font;
}

+ (UIFont *)kg_semibold20Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedSemiboldFontName size:20.f])
    return font;
}

+ (UIFont *)kg_semibold18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedSemiboldFontName size:18.f])
    return font;
}


#pragma mark - Regular

+ (UIFont *)kg_regular14Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedRegularFontName size:14.f])
    return font;
}

+ (UIFont *)kg_regular16Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedRegularFontName size:16.f])
    return font;
}
+ (UIFont *)kg_regular18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedRegularFontName size:18.f])
    return font;
}


#pragma mark - Light

+ (UIFont *)kg_light18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedLightFontName size:18.f])
    return font;
}

@end

