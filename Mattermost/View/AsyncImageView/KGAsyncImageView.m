//
//  KGAsyncImageView.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAsyncImageView.h"

@implementation KGAsyncImageView {
    CGImageRef bgImage;
}

-(void)prepBGImage {
    bgImage = self.backgroundImage.CGImage;
    CGRect rect = self.bounds;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, rect.size.width * (CGColorSpaceGetNumberOfComponents(space) + 1), space, kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(space);
        
        /* do expensive drawing in this context */
        
        bgImage = CGBitmapContextCreateImage(ctx);
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self setNeedsDisplayInRect:rect];
        });
    });
}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /* do drawing behind this ... */
    if (CGRectIntersectsRect(rect, self.bounds)) {
        CGContextDrawImage(ctx, rect, bgImage);
    }
        /* do drawing in front of this */

}

@end
