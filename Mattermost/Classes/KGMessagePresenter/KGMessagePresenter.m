//
//  KGMessagePresenter.m
//  Mattermost
//
//  Created by Igor Vedeneev on 16.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGMessagePresenter.h"
#import "KGPost.h"
#import "KGChannel.h"
#import "KGUIUtils.h"
#import "KGUser.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "UIImageView+WebCache.h"
#import "UIFont+KGPreparedFont.h"
#import "KGBusinessLogic+Session.h"

@import UIKit;

@interface KGMessagePresenter()

@property (nonatomic, strong) UIView *notificationView;

@end

@implementation KGMessagePresenter

- (void)presentNotificationWithMessage:(KGPost *)post {
    if ([self needToDisplayPost:post]) {
        if (self.notificationView) {
            [self.notificationView removeFromSuperview];
            self.notificationView = nil;
        }
        self.notificationView = [self notificationViewWithPost:post];
        self.notificationView.frame = CGRectMake(0, -64, KGScreenWidth(), 64);
        [self presentNotificationViewAnimated];
    }
}


#pragma mark - Private

- (UIView *)notificationViewWithPost:(KGPost *)post {
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KGScreenWidth(), 64)];
    notificationView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.92];

    [self setupTitleForNotificationView:notificationView withPost:post];
    [self setupMessageForNotificationView:notificationView withPost:post];
    [self setupCloseButtonForNotificationView:notificationView];
    [self setupSwipeGestureForNotificationView:notificationView];
    
    return notificationView;
}

- (void)setupAvatarForNotificationView:(UIView *)notificationView withPost:(KGPost *)post {
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 40, 40)];
    [notificationView addSubview:avatarImageView];
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    //[avatarImageView setImageWithURL:post.author.imageUrl usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = avatarImageView.center;
    activityIndicator.hidesWhenStopped = YES;
    [avatarImageView sd_setImageWithURL:post.author.imageUrl
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [activityIndicator removeFromSuperview];
        
    }];
    [avatarImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)setupTitleForNotificationView:(UIView *)notificationView withPost:(KGPost *)post {
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 14, KGScreenWidth() - 86, 18)];
    [notificationView addSubview:nicknameLabel];
    nicknameLabel.textColor = [UIColor whiteColor];
    nicknameLabel.font = [UIFont kg_semibold16Font];
    NSString *text = @"";
    if (post.author) {
        text = [@"@" stringByAppendingString:post.author.nickname];
    }
    if (post.channel.type == KGChannelTypePublic) {
        text = [NSString stringWithFormat:@"%@(%@)", text, post.channel.displayName];
    }
    nicknameLabel.text = text;
    
}

- (void)setupMessageForNotificationView:(UIView *)notificationView withPost:(KGPost *)post {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 33, KGScreenWidth() - 86, 17)];
    [notificationView addSubview:messageLabel];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont kg_regular15Font];
    messageLabel.text = post.message;
}

- (void)setupCloseButtonForNotificationView:(UIView *)notificationView {
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(KGScreenWidth() - 29, 22, 20, 20)];
    [notificationView addSubview:closeButton];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hideNotificationViewAnimated) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSwipeGestureForNotificationView:(UIView *)notificationView {
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNotificationViewAnimated)];
    notificationView.userInteractionEnabled = YES;
    [notificationView addGestureRecognizer:swipeGestureRecognizer];
}

- (void)presentNotificationViewAnimated {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.notificationView];
    [UIView animateWithDuration:0.3 animations:^{
        self.notificationView.frame = CGRectMake(0, 0, KGScreenWidth(), 64);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideNotificationViewAnimated) withObject:nil afterDelay:2];
    }];
}

- (void)hideNotificationViewAnimated {
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window addSubview:self.notificationView];
    [UIView animateWithDuration:0.3 animations:^{
        self.notificationView.frame = CGRectMake(0, -64, KGScreenWidth(), 64);
    } completion:^(BOOL finished) {
        [self.notificationView removeFromSuperview];
        self.notificationView = nil;
    }];
}


#pragma mark - Helper

- (BOOL)needToDisplayPost:(KGPost *)post {
    if (post.message.length == 0) {
        return NO;
    }
    
    return YES;
}

@end
