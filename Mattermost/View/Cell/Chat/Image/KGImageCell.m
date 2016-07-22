//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"
#import "UIColor+KGPreparedColor.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGFile.h"
#import "UIImage+Resize.h"
#import "KGDrawer.h"

#define KG_IMAGE_WIDTH  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f)
#define KG_IMAGE_HEIGHT  (ceilf((CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.56f - 5.f))

@interface KGImageCell ()
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) KGFile* file;
@end

@implementation KGImageCell
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupImageView];
    }
    
    return self;
}


- (void)setupImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT)];
    [self.imageView setBackgroundColor:[UIColor kg_whiteColor]];
    [self.imageView setContentMode: UIViewContentModeScaleAspectFit];
    self.imageView.image = KGRoundedPlaceholderImageForAttachmentsCell(CGSizeMake(KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT));
    [self addSubview:self.imageView];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;
        self.file = file;
        NSURL *url = file.thumbLink;
        __weak typeof(self) wSelf = self;

        __block NSString* smallImageKey = [url.absoluteString stringByAppendingString:@"_thumb"];
        UIImage* smallImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:smallImageKey];
        if (smallImage) {
            self.imageView.image = smallImage;
        } else {
            if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:smallImageKey]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageKey];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.imageView.image = image;
                    });
                });
            } else {
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageHandleCookies progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                    CGFloat widthToHeight = image.size.width/image.size.height;
//                    CGFloat scaleFactor = KG_IMAGE_HEIGHT / image.size.height;
//                    CGSize imageSize = CGSizeMake(image.size.height * scaleFactor * widthToHeight, image.size.height * scaleFactor);
                    if(image) {
                        [UIImage roundedImage:image
                                  whithRadius:3
                                         size:CGSizeMake(KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT)
                                   completion:^(UIImage *roundedImage) {
                                       if ([wSelf.file.thumbLink isEqual:url]) { // It is till the same cell
                                           wSelf.imageView.image = roundedImage;
                                       }
                                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                           [[SDImageCache sharedImageCache] storeImage:roundedImage forKey:smallImageKey];
                                       });
                                   }];
                    }

                }];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
   
}

- (void)prepareForReuse {
    self.imageView.image = nil;
    self.file = nil;
    
}

@end
