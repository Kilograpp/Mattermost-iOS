//
//  KGHeaderRightMenuCell.m
//  Mattermost
//
//  Created by Mariya on 17.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGHeaderRightMenuCell.h"
#import "KGUser.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGRightMenuDataSourceEntry.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

const static CGFloat KGHeightAvatar = 35;

@interface KGHeaderRightMenuCell()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *titleMenuLabel;

@end

@implementation KGHeaderRightMenuCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
        [self setupGestureRecognizer];
        [self setupTitleLabel];
        [self setupIconImageView];
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupContentView {
    self.backgroundColor = [UIColor kg_leftMenuHeaderColor];
    self.preservesSuperviewLayoutMargins = NO;
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileAction)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)setupTitleLabel {
    _titleMenuLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 22, 245, 21)];
    _titleMenuLabel.numberOfLines = 1;
    _titleMenuLabel.backgroundColor = [UIColor kg_leftMenuHeaderColor];
    _titleMenuLabel.font = [UIFont kg_semibold16Font];
    _titleMenuLabel.textColor = [UIColor kg_whiteColor];
    [self addSubview:_titleMenuLabel];
}

- (void)setupIconImageView {
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 15, KGHeightAvatar, KGHeightAvatar)];
    _avatarImageView.backgroundColor = [UIColor kg_whiteColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.layer.cornerRadius = KGHeightAvatar / 2;
    _avatarImageView.clipsToBounds = YES;
    [self addSubview:_avatarImageView];
    self.center = _avatarImageView.center;
}

#pragma mark - Public

- (void)configureWithObject:(id)object {
    KGUser *user = object;

    
    NSString* smallAvatarKey = [user.imageUrl.absoluteString stringByAppendingString:@"_feed"];
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:smallAvatarKey]) {
        UIImage *smallAvatar = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallAvatarKey];
        self.avatarImageView.image = smallAvatar;
    } else {
        [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }

    _titleMenuLabel.text = [@"@" stringByAppendingString:user.nickname];

}


- (void)updateAvatarImage {
    
}

#pragma mark - Action

- (void)profileAction{
    self.handler();
}


@end
