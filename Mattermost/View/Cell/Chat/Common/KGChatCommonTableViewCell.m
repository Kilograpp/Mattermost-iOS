//
//  KGChatCommonTableViewCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatCommonTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "KGPost.h"
#import "KGUser.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+HeightCalculation.h"
#import "UIImage+Resize.h"

@import AsyncDisplayKit;

@interface KGChatCommonTableViewCell ()

@end

@implementation KGChatCommonTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupAvatarImageView];
        [self setupNameLabel];
        [self setupDateLabel];
        [self setupMessageLabel];
        
        for (UIView *view in self.subviews) {
//            view.layer.drawsAsynchronously = YES;
            view.layer.shouldRasterize = YES;
            view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        }
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupAvatarImageView {
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_avatarImageView];
    _avatarImageView.layer.drawsAsynchronously = YES;
    _avatarImageView.layer.cornerRadius = 20.f;
    self.avatarImageView.backgroundColor = [UIColor kg_whiteColor];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.image = [[self class] placeholderBackground];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(kStandartPadding);
        make.width.height.equalTo(@(kAvatarDimension));
    }];
}

- (void)setupNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.nameLabel];
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self.nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarImageView.mas_trailing).offset(kSmallPadding);
        make.top.equalTo(self).offset(8.f);
    }];
}

- (void)setupDateLabel {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.dateLabel];
    self.dateLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateLabel.textColor = [UIColor kg_lightGrayColor];
    self.dateLabel.font = [UIFont kg_regular13Font];
    self.dateLabel.contentMode = UIViewContentModeLeft;
    [self.dateLabel setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(kSmallPadding);
        make.centerY.equalTo(self.nameLabel);
        make.trailing.equalTo(self).offset(-kStandartPadding);
    }];
}

- (void)setupMessageLabel {
    self.messageLabel = [[ActiveLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.messageLabel];
    self.messageLabel.backgroundColor = [UIColor kg_whiteColor];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
    [self.messageLabel setURLColor:[UIColor kg_blueColor]];
    [self.messageLabel setURLSelectedColor:[UIColor blueColor]];
    [self.messageLabel setMentionSelectedColor:[UIColor blueColor]];

    self.messageLabel.textColor = [UIColor kg_blackColor];
    self.messageLabel.font = [UIFont kg_regular15Font];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.messageLabel.preferredMaxLayoutWidth = 200.f;

    [self.messageLabel handleMentionTap:^(NSString *string) {
        self.mentionTapHandler(string);
    }];
    [self.messageLabel handleURLTap:^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];

    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.trailing.equalTo(self).offset(-kStandartPadding);
        make.bottom.equalTo(self).offset(-kStandartPadding);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        self.messageLabel.text = post.message;
        self.nameLabel.text = post.author.nickname;
        self.dateLabel.text = [post.createdAt timeFormatForMessages];
 
        
        for (UIView *view in self.subviews) {
            view.backgroundColor = post.identifier ? [UIColor kg_whiteColor] : [UIColor colorWithWhite:0.95f alpha:1.f];
        }

//        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:post.author.imageUrl.absoluteString];
//        if (cachedImage) {
//            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
//                self.avatarImageView.image = image;
//            }];
//        } else {
//            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:post.author.imageUrl
//                                                                  options:SDWebImageDownloaderHandleCookies
//                                                                 progress:nil
//                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                        [[self class] roundedImage:image completion:^(UIImage *image) {
//                            [[SDImageCache sharedImageCache] storeImage:image forKey:post.author.imageUrl.absoluteString];
//                            self.avatarImageView.image = image;
//                        }];
//            }];
//            [self.avatarImageView removeActivityIndicator];
//        }
        [self.avatarImageView setImageWithURL:post.author.imageUrl
                             placeholderImage:[[self class] placeholderBackground]
                                      options:SDWebImageHandleCookies
                                    completed:nil
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.avatarImageView removeActivityIndicator];
        
      //  self.backgroundColor = (!post.isUnread) ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
        
    }
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat messageLabelWidth = screenWidth - kAvatarDimension - kStandartPadding * 2 - kSmallPadding;
        CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
        CGFloat nameMessage = 24.f;//[post.author.nickname heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_semibold16Font]];
        CGFloat heightCell = kStandartPadding + nameMessage + kSmallPadding + heightMessage + kStandartPadding;
        
        return  ceilf(heightCell);
    }
    
    return 0.f;
}


#pragma mark - Override

- (void)prepareForReuse {
    self.avatarImageView.image = nil;
    self.avatarImageView.image = [[self class] placeholderBackground];
}


#pragma mark - Images

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
        
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:image.size.width/2] addClip];
        [image drawInRect:rect];
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(roundedImage);
            }
        });
    });
}



@end
