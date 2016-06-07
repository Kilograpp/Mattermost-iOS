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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:KGPreparedBoldFontName size:fontSize];
//}
//
//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:KGPreparedRegularFontName size:fontSize];
//}

+ (UIFont *)kg_semibold30Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedSemiboldFontName size:30.f])
    return font;
}

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

+ (UIFont *)kg_light18Font {
    STATIC_ONCE(font, [UIFont fontWithName:KGPreparedLightFontName size:18.f])
    return font;
}
//+ (UIFont *)semiBoldSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:KGPreparedSemiboldFontName size:fontSize];
//}
#pragma clang diagnostic pop

@end

