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
//    _avatarImageView = [[ASNetworkImageNode alloc] init];
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_avatarImageView/*.view*/];
    _avatarImageView.layer.drawsAsynchronously = YES;
//    self.avatarImageView.view.layer.cornerRadius = kAvatarDimension / 2;
//    self.avatarImageView.layer.cornerRadius = kAvatarDimension / 2;
    self.avatarImageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.f];
    self.avatarImageView.clipsToBounds = YES;
    
    [self.avatarImageView/*.view*/ mas_makeConstraints:^(MASConstraintMaker *make) {
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

    [self.nameLabel setContentCompressionResistancePriority: 749 forAxis: UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(53.f);
        make.top.equalTo(self).offset(8.f);
//        make.trailing.lessThanOrEqualTo(self).offset(-75.f);
    }];
}

- (void)setupDateLabel {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.dateLabel];
    self.dateLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateLabel.textColor = [UIColor kg_lightGrayColor];
    self.dateLabel.font = [UIFont kg_regular13Font];
    self.dateLabel.contentMode = UIViewContentModeLeft;
    //NSLog(@"nameLabel.width %f",self.nameLabel.frame.size.width);
//    self.dateLabel
    [self.dateLabel setContentCompressionResistancePriority: 750 forAxis: UILayoutConstraintAxisHorizontal];
    [self.dateLabel setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(self.nameLabel.mas_trailing).offset(kSmallPadding);
//        make.leading.equalTo(self.nameLabel).offset(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width);
        make.centerY.equalTo(self.nameLabel);
        make.trailing.equalTo(self).offset(-kStandartPadding);
        
    }];
}

- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.messageLabel];
    self.messageLabel.backgroundColor = [UIColor kg_whiteColor];
    self.messageLabel.textColor = [UIColor kg_blackColor];
    self.messageLabel.font = [UIFont kg_regular15Font];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.messageLabel.preferredMaxLayoutWidth = 200.f;
    
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
        dispatch_queue_t bgQueue = dispatch_get_global_queue(0, 0);
        __weak typeof(self) wSelf = self;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:post.author.imageUrl.absoluteString];
        if (cachedImage) {
            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
                self.avatarImageView.image = image;
//                [self.avatarImageView setNeedsDisplay];
            }];
        } else {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:post.author.imageUrl
                                                                  options:SDWebImageDownloaderHandleCookies
                                                                 progress:nil
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        [[self class] roundedImage:image completion:^(UIImage *image) {
                            [[SDImageCache sharedImageCache] storeImage:image forKey:post.author.imageUrl.absoluteString];
                            self.avatarImageView.image = image;
                        }];
            }];
            [self.avatarImageView removeActivityIndicator];
        }
        
        //        [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
        //                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat messageLabelWidth = screenWidth - kAvatarDimension - kStandartPadding * 2 - kSmallPadding;
        CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
        CGFloat nameMessage = [post.author.nickname heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_semibold16Font]];
        CGFloat heightCell = kStandartPadding + nameMessage + kSmallPadding + heightMessage + kStandartPadding;
        
        return  ceilf(heightCell);
    }
    
    return 0.f;
}

- (void)prepareForReuse {
    self.avatarImageView.image = [[self class] placeholderBackground];
//    self.nameLabel.text = nil;
//    self.dateLabel = nil;
//    self.messageLabel = nil;
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
                                    cornerRadius:image.size.width/2] addClip];
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

+ (UIImage *)placeholderBackground {
//    CGRect rect = CGRectMake(0, 0, 1, 1);
    CGRect rect = CGRectMake(0, 0, 40, 40);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
