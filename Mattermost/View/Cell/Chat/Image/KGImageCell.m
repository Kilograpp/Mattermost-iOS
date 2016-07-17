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
#import "KGDrawer.h"

#define KG_IMAGE_WIDTH  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f)
#define KG_IMAGE_HEIGHT  ((CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.56f - 5.f)

@interface KGImageCell ()
@property (nonatomic, strong) UIImage *kg_image;
@property (nonatomic, strong) KGFile* file;
@end

@implementation KGImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    [[KGDrawer sharedInstance] drawImage:self.kg_image inRect:rect];
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
            self.kg_image = smallImage;
        } else {
            if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:smallImageKey]) {
                smallImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallImageKey];
                self.kg_image = smallImage;
            } else {
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageHandleCookies progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    CGFloat scaleFactor = KG_IMAGE_HEIGHT / image.size.height;
                    CGSize imageSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
                    if(image) {
                        [UIImage roundedImage:image
                                  whithRadius:3
                                         size:imageSize
                                   completion:^(UIImage *image) {
                                       
                                       if ([wSelf.file.thumbLink isEqual:url]) { // It is till the same cell
                                           wSelf.kg_image = image;
                                           [wSelf setNeedsDisplay];
                                       }
                                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                           [[SDImageCache sharedImageCache] storeImage:image forKey:smallImageKey];
                                       });
                                   }];
                    }

                }];
            }
        }
    }
}

- (void)prepareForReuse {
    self.kg_image = nil;
    self.file = nil;
    
}

@end
