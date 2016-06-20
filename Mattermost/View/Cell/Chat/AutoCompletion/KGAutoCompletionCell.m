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

@interface KGAutoCompletionCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImagView;
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
    
    self.nameUserLabel.font = [UIFont kg_regular13Font];
    self.nameUserLabel.textColor = [UIColor kg_grayColor];
    
    self.contentView.backgroundColor = [UIColor kg_whiteColor];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGUser class]]) {
        KGUser *user = object;
        
        self.nickUserLabel.text = [NSString stringWithFormat:@"@%@", user.nickname];
        NSString *userFirstName = (!user.firstName) ? @"" : user.firstName;
        NSString *userLastName = (!user.lastName) ? @"" : user.lastName;
        self.nameUserLabel.text = [NSString stringWithFormat:@"%@ %@", userFirstName, userLastName];
        
        UIImageView *cachedImage;
        [cachedImage setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies completed:nil
         usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
        if (cachedImage) {
            [UIImage roundedImage:cachedImage.image completion:^(UIImage *image) {
                self.avatarImagView.image = image;
                [self.avatarImagView setNeedsDisplay];
            }];
        } else {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:user.imageUrl
                                                                  options:SDWebImageDownloaderHandleCookies
                                                                 progress:nil
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    [UIImage roundedImage:image completion:^(UIImage *image) {
                                                                        [[SDImageCache sharedImageCache] storeImage:image forKey:user.imageUrl.absoluteString];
                                                                        self.avatarImagView.image = image;
                                                                    }];
                                                                }];
             [self.avatarImagView removeActivityIndicator];
        }
    }
}

+ (CGFloat)heightWithObject:(id)object {
    return 44;
}


@end
