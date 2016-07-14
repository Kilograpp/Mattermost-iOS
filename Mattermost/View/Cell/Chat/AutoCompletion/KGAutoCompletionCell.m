//
//  KGAutoCompletionCell.m
//  Mattermost
//
//  Created by Mariya on 20.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAutoCompletionCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"
#import "KGUser.h"

#import "KGCommand.h"

static CGFloat const kHeightCell = 44;

@interface KGAutoCompletionCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameUserLabel;


@end

@implementation KGAutoCompletionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupLabel];

}

- (void)setupLabel {
    self.nickUserLabel.font = [UIFont kg_boldText16Font];
    self.nickUserLabel.textColor = [UIColor kg_blackColor];
    self.nickUserLabel.backgroundColor = [UIColor kg_whiteColor];
    
    self.nameUserLabel.font = [UIFont kg_regular13Font];
    self.nameUserLabel.textColor = [UIColor kg_grayColor];
    self.nameUserLabel.backgroundColor = [UIColor kg_whiteColor];
    
    self.contentView.backgroundColor = [UIColor kg_whiteColor];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGUser class]]) {
        
        KGUser *user = object;
        
        self.nickUserLabel.text = [NSString stringWithFormat:@"@%@", user.nickname];
        
        NSString *userFirstName = (!user.firstName) ? @"" : user.firstName;
        NSString *userLastName = (!user.lastName) ? @"" : user.lastName;
        self.nameUserLabel.text = [NSString stringWithFormat:@"%@ %@", userFirstName, userLastName];
        
        __weak typeof(self) wSelf = self;
            [self.avatarImageView setImageWithURL:user.imageUrl
                                 placeholderImage:KGRoundedPlaceholderImage(CGSizeMake(34, 34))
                                          options:SDWebImageHandleCookies | SDWebImageAvoidAutoSetImage
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            UIImage *roundedImage = KGRoundedImage(image, CGSizeMake(34, 34));
                                            wSelf.avatarImageView.image = roundedImage;
                                        }
                      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.avatarImageView removeActivityIndicator];
        }

}
//        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:user.imageUrl.absoluteString];
//        if (cachedImage) {
//            [UIImage roundedImage:cachedImage completion:^(UIImage *image) {
//                self.avatarImageView.image = image;
////                [self.avatarImageView setNeedsDisplay];
//            }];
//        } else {
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:user.imageUrl
//                                                                  options:SDWebImageDownloaderHandleCookies
//                                                                 progress:nil
//                                                                completed:^(UIImage* image, NSData* data, NSError* error, BOOL finished) {
//                                                                    [UIImage roundedImage:image completion:^(UIImage* image) {
//                                                                        [[SDImageCache sharedImageCache] storeImage:image forKey:user.imageUrl.absoluteString];
//                                                                        self.avatarImageView.image = image;
//                                                                    }];
//                                                                }];
//            [self.avatarImageView removeActivityIndicator];
//        }
//    }
//}

+ (CGFloat)heightWithObject:(id)object {
    return kHeightCell;
}


@end
