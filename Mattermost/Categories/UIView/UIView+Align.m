//
//  UIView+Align.m
//  Mattermost
//
//  Created by Maxim Gubin on 09/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIView+Align.h"

@implementation UIView (Align)

- (void)align {
    self.frame = CGRectMake(ceilf(self.frame.origin.x),
                            ceilf(self.frame.origin.y),
                            ceilf(self.frame.size.width),
                            ceilf(self.frame.size.height));
}

- (void)alignSubviews {
    for (UIView* view in self.subviews) {
        [view align];
    }
}

@end
