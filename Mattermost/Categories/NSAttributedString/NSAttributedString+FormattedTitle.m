//
//  NSAttributedString+FormattedTitle.m
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSAttributedString+FormattedTitle.h"
#import "Bostring.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"

@implementation NSAttributedString (FormattedTitle)

+ (instancetype)settingLabel:(NSString *)stringName stringTime:(NSString *)stringTime {
    
    NSAttributedString *attributedString = [stringTime bos_makeString:^(BOStringMaker *make) {
        //начало
        make.foregroundColor([UIColor kg_blackColor]); //цвет шрифта для stringName
        make.font([UIFont kg_semibold16Font]);
        
        // остальное
        make.with.range(NSMakeRange(0 /*с какой позиции*/, stringName.length /*кол-во задействованных букв*/), ^{
            make.foregroundColor([UIColor kg_lightGrayColor]); //цвет для stringTime
            make.font([UIFont kg_light16Font]);
            
        });
    }];
    
    return attributedString;
}



@end
