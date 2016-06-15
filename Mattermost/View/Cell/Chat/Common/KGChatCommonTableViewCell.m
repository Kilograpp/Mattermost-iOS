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
        self.avatarImageView.backgroundColor = [UIColor greenColor];
        self.nameLabel.backgroundColor = [UIColor grayColor];
        self.dateLabel.backgroundColor = [UIColor redColor];
        self.messageLabel.backgroundColor = [UIColor blueColor];
        
        for (UIView *view in self.subviews) {
            view.layer.drawsAsynchronously = YES;
        }
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupAvatarImageView {
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.avatarImageView];
    self.avatarImageView.layer.drawsAsynchronously = YES;
    self.avatarImageView.layer.cornerRadius = kAvatarDimension / 2;
    self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
    self.avatarImageView.clipsToBounds = YES;
    
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
    
    [self.nameLabel setContentCompressionResistancePriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisHorizontal];
    
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
    [self.dateLabel setContentCompressionResistancePriority: UILayoutPriorityDefaultHigh forAxis: UILayoutConstraintAxisHorizontal];
    
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
    self.messageLabel.textColor = [UIColor kg_blackColor];
    self.messageLabel.font = [UIFont kg_regular15Font];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.messageLabel.preferredMaxLayoutWidth = 200.f;
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_leading);
        make.trailing.equalTo(self);
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
        
        [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self.avatarImageView removeActivityIndicator];
        
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


@end
