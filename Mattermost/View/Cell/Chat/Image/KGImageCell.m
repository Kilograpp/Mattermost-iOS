//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGFile.h"
#import "UIImage+Resize.h"

#define KG_IMAGE_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.56f - 5.f

@interface KGImageCell ()
@end

@implementation KGImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupImageView];
    }
    
    return self;
}

- (void)setupImageView {
    self.kg_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.kg_imageView.layer.drawsAsynchronously = YES;
    self.layer.drawsAsynchronously = YES;
    self.kg_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.kg_imageView];
    self.layer.shouldRasterize = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.kg_imageView.clipsToBounds = YES;
}


- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;

        NSURL *url = file.thumbLink;
        __weak typeof(self) wSelf = self;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        if (cachedImage) {
            wSelf.kg_imageView.image = cachedImage;
        } else {
            [self.kg_imageView setImageWithURL:url
                                 placeholderImage:KGRoundedPlaceholderImageForAttachmentsCell(CGSizeMake(KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT))
                                          options:SDWebImageHandleCookies
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.kg_imageView removeActivityIndicator];
        }
    }
}

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);

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
    self.kg_imageView.image = nil;
}

+ (UIImage *)placeholderBackground {
    CGRect rect = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef ref = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.f].CGPath;
    CGContextAddPath(context, ref);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews {
    self.kg_imageView.frame = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
}

@end
