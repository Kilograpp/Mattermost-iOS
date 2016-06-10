//
//  NSString+HeightCalculation.m
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSString+HeightCalculation.h"

@implementation NSString (HeightCalculation)

- (CGFloat)heightForTextWithWidth:(CGFloat)textWidth withFont:(UIFont *)fontType {
    //метод расчета размера текстового поля
    NSAttributedString* attributedString = nil;
    
    UIFont* font = fontType;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    [paragraph setLineSpacing:fontType.pointSize];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName, nil];
    
    
    attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CGRect rect = CGRectIntegral([attributedString boundingRectWithSize:CGSizeMake(textWidth , CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil]);
    return CGRectGetHeight(rect);
}

@end
