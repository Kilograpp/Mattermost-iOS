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

        NSURL *url = file.thumbLink;
        __weak typeof(self) wSelf = self;

        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageHandleCookies progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            CGFloat scaleFactor = KG_IMAGE_HEIGHT / image.size.height;
            if (!wSelf.kg_image) {
                wSelf.kg_image = image;
            }
            CGSize imageSize = CGSizeMake(wSelf.kg_image.size.width * scaleFactor, wSelf.kg_image.size.height * scaleFactor);
            if(wSelf.kg_image) {
                [UIImage roundedImage:wSelf.kg_image
                          whithRadius:3
                                 size:imageSize
                           completion:^(UIImage *image) {
                               wSelf.kg_image = image;
                               //[wSelf setNeedsLayout];
                               [wSelf setNeedsDisplay];
                               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString];
                               });
                           }];
            }

        }];
    
    }
}

- (void)prepareForReuse {
    self.kg_image = nil;
}

@end
