//
//  KGUIUtils.m
//  Mattermost
//
//  Created by Igor Vedeneev on 28.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGUIUtils.h"

@implementation KGUIUtils

CGFloat KGScreenWidth() {
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

CGFloat KGScreenHeight() {
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

@end
