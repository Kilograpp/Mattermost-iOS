//
//  UIFont+KGPreparedFont.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIFont+KGPreparedFont.h"
#import "KGUtils.h"

NSString *const KGPreparedRegularFontName = @"OpenSans-Regular";
NSString *const KGPreparedBoldFontName = @"OpenSans-Bold";
NSString *const KGPreparedSemiboldFontName = @"OpenSans-Semibold";
NSString *const KGPreparedItalicFontName = @"OpenSans";

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

//+ (UIFont *)semiBoldSystemFontOfSize:(CGFloat)fontSize {
//    return [UIFont fontWithName:KGPreparedSemiboldFontName size:fontSize];
//}
#pragma clang diagnostic pop

@end

