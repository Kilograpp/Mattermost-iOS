//
//  KGButton.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGButton.h"
#import "UIColor+KGPreparedColor.h"

@implementation KGButton

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    
    
//    self.backgroundColor = highlighted ? [UIColor kg_blueColor]: [UIColor whiteColor];
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [self setTitleColor:[UIColor kg_blueColor] forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled == NO){
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.6];
    } else {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1.f];
    }
}

@end
