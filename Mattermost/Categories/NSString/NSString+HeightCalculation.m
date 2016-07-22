//
//  NSString+HeightCalculation.m
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSString+HeightCalculation.h"
#import <BOString.h>

@implementation NSString (HeightCalculation)

- (CGFloat)kg_heightForTextWidth:(CGFloat)textWidth font:(UIFont *)fontType {
    NSAttributedString* messageAttributedString = [self bos_makeString:^(BOStringMaker *make) {
        make.font(fontType);
    }];
    
    CGRect rect = [messageAttributedString boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        context:nil];
    return CGRectGetHeight(rect);
}

@end
