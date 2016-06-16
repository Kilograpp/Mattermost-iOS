//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>
#import <Masonry.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define KG_IMAGE_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.66f - 5.f

@implementation KGImageCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
//    self.kg_imageView = [[ASNetworkImageNode alloc] init];
    self.kg_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.kg_imageView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f];
    self.kg_imageView.layer.drawsAsynchronously = YES;
    self.layer.drawsAsynchronously = YES;
    self.kg_imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.kg_imageView/*.view*/];
    self.layer.shouldRasterize = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.kg_imageView/*.view*/.layer.cornerRadius = 5.f;
    self.kg_imageView/*.view*/.clipsToBounds = YES;

    [self.kg_imageView/*.view*/ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-8.f);
    }];
}


- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[NSURL class]]) {
        NSURL *url = object;
//        self.kg_imageView.URL = url;
        
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        if (cachedImage) {
            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
                self.kg_imageView.image = image;
            }];
        } else {
            dispatch_queue_t bgQueue = dispatch_get_global_queue(0, 0);
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                                  options:SDWebImageDownloaderHandleCookies
                                                                 progress:nil
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    dispatch_async(bgQueue, ^{
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            [[self class] roundedImage:image completion:^(UIImage *image) {
                                                                                [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString];
                                                                                self.kg_imageView.image = image;
                                                                            }];
                                                                        });
                                                                    });
                                                                }];
            [self.kg_imageView removeActivityIndicator];
        }

    }
}

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:15.f] addClip];
        // Draw your image
        [image drawInRect:rect];
        
        // Get the image, here setting the UIImageView image
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        dispatch_async( dispatch_get_main_queue(), ^{
            if (completion) {
                completion(roundedImage);
            }
        });
    });
}

- (void)prepareForReuse {
    self.kg_imageView.image = nil;
}

+ (UIImage *)placeholderBackground {
    //    CGRect rect = CGRectMake(0, 0, 1, 1);
    CGRect rect = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
//    CGContextFillRect(context, rect);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:15.0];
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.95f alpha:1.f].CGColor);
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
