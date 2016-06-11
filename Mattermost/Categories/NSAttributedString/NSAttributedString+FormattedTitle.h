//
//  NSAttributedString+FormattedTitle.h
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (FormattedTitle)

+ (instancetype)settingLabel:(NSString *)stringName stringTime:(NSString *)stringTime;

@end
