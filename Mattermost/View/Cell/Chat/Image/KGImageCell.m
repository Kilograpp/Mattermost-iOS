//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"
#import <Masonry/Masonry.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGFile.h"
#import "UIImage+Resize.h"

#define KG_IMAGE_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.66f - 5.f

@interface KGImageCell ()
@end

@implementation KGImageCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
//    self.kg_imageView = [[ASNetworkImageNode alloc] init];
    self.kg_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.kg_imageView.layer.drawsAsynchronously = YES;
    self.layer.drawsAsynchronously = YES;
    self.kg_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.kg_imageView/*.view*/];
    self.layer.shouldRasterize = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.kg_imageView/*.view*/.layer.cornerRadius = 5.f;
    self.kg_imageView/*.view*/.clipsToBounds = YES;

    [self.kg_imageView/*.view*/ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-8.f);
        make.top.equalTo(self).offset(8.f);
    }];
}




- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;
//        if (!file.downloadLink) {
            UIImage *cachedImage_ = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:file.backendLink];
        if (cachedImage_) {
            self.kg_imageView.image = cachedImage_;
            return;
        }
//        }
        NSURL *url = file.thumbLink;
//            NSURL *url = file.downloadLink;
        
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        if (cachedImage) {
            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
                self.kg_imageView.image = image;
            }];
        } else {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                                  options:SDWebImageDownloaderHandleCookies
                                                                 progress:nil
                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                            [[self class] roundedImage:image completion:^(UIImage *image) {
                                [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString];
                                self.kg_imageView.image = image;
                            }];
                }];
//            [self.kg_imageView removeActivityIndicator];
        }
    }
}

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
//        CGRect rect = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);

        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:5.f] addClip];
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
    self.kg_imageView.image = [[self class] placeholderBackground];
}

+ (UIImage *)placeholderBackground {
    CGRect rect = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"%@", context);
    CGPathRef ref = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.f].CGPath;
    CGContextAddPath(context, ref);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
