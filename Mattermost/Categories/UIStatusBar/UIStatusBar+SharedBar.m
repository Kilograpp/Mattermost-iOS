//
// Created by Maxim Gubin on 23/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "UIStatusBar+SharedBar.h"

static UIStatusBar* sharedStatusBar;

@implementation UIStatusBar (SharedBar)

+ (instancetype)sharedStatusBar {
    return sharedStatusBar;
}

- (void) drawRect:(CGRect)rect {
    if (!sharedStatusBar) {
        @synchronized (sharedStatusBar) {
            sharedStatusBar = self;
        }
    }
}

@end