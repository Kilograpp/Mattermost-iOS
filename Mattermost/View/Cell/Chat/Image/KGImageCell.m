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

#define KG_IMAGE_WIDTH  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f)
#define KG_IMAGE_HEIGHT  ((CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.56f - 5.f)

@interface KGImageCell ()
@property (nonatomic, strong) UIImage *kg_image;
@property (assign) CGSize imageSize;
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
    self.kg_imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.kg_imageView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.kg_imageView.clipsToBounds = YES;
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;

        NSURL *url = file.thumbLink;
        __weak typeof(self) wSelf = self;

        [self.kg_imageView setImageWithURL:url
                             placeholderImage:KGRoundedPlaceholderImageForAttachmentsCell(CGSizeMake(KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT))
                                      options:SDWebImageHandleCookies | SDWebImageAvoidAutoSetImage
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat scaleFactor = KG_IMAGE_HEIGHT / image.size.height;
                    if (!wSelf.kg_image) {
                        wSelf.kg_image = image;
                    }
                    wSelf.imageSize = CGSizeMake(wSelf.kg_image.size.width * scaleFactor, wSelf.kg_image.size.height * scaleFactor);
                    if(wSelf.kg_image) {
                        [UIImage roundedImage:wSelf.kg_image
                                  whithRadius:3
                                         size:wSelf.imageSize
                                   completion:^(UIImage *image) {
                                       wSelf.kg_imageView.image = image;
                                       [wSelf setNeedsLayout];
                                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                           [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString];
                                       });
                                   }];
                    }
                    
    }
               usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.kg_imageView removeActivityIndicator];
    }
}

- (void)prepareForReuse {
    self.kg_imageView.image = nil;
    self.kg_image = nil;
}

- (void)layoutSubviews {
    if (self.kg_image) {
        self.kg_imageView.frame = CGRectMake(0, 0, self.kg_image.size.width, self.kg_image.size.height);
    } else {
        self.kg_imageView.frame = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
    }
    
}

@end
