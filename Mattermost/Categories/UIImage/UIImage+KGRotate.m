//
//  UIImage+KGRotate.m
//  Mattermost
//
//  Created by Igor Vedeneev on 17.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "UIImage+KGRotate.h"

@implementation UIImage (KGRotate)

- (instancetype)kg_normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}


@end
