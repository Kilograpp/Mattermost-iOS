//
//  KGMessagePresenter.m
//  Mattermost
//
//  Created by Igor Vedeneev on 16.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGMessagePresenter.h"
#import "KGPost.h"
#import "KGUIUtils.h"
#import "KGUser.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "UIFont+KGPreparedFont.h"
@import UIKit;

@interface KGMessagePresenter()
@property (nonatomic, strong) UIView *notificationView;
@end

@implementation KGMessagePresenter

- (void)presentNotificationWithMessage:(KGPost *)post {
    if (self.notificationView) {
        [self.notificationView removeFromSuperview];
        self.notificationView = nil;
    }
    self.notificationView = [self notificationViewWithPost:post];
    self.notificationView.frame = CGRectMake(0, -64, KGScreenWidth(), 64);
    [self presentNotificationViewAnimated];
}


#pragma mark - Private

- (UIView *)notificationViewWithPost:(KGPost *)post {
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KGScreenWidth(), 64)];
    notificationView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.92];
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 40, 40)];
    [notificationView addSubview:avatarImageView];
    avatarImageView.layer.cornerRadius = 20;
    avatarImageView.clipsToBounds = YES;
    [avatarImageView setImageWithURL:post.author.imageUrl usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 14, KGScreenWidth() - 86, 18)];
    [notificationView addSubview:nicknameLabel];
    nicknameLabel.textColor = [UIColor whiteColor];
    nicknameLabel.font = [UIFont kg_semibold16Font];
    if (post.author) {
        nicknameLabel.text = [@"@" stringByAppendingString:post.author.nickname];
    }
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 33, KGScreenWidth() - 86, 17)];
    [notificationView addSubview:messageLabel];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont kg_regular15Font];
    messageLabel.text = post.message;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(KGScreenWidth() - 29, 22, 20, 20)];
    [notificationView addSubview:closeButton];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hideNotificationViewAnimated) forControlEvents:UIControlEventTouchUpInside];
    
    return notificationView;
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

@end
