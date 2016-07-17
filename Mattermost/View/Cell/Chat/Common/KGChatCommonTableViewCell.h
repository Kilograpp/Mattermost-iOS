//
//  KGChatCommonTableViewCell.h
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
#import "KGUIUtils.h"
@class ActiveLabel, KGPost, DGActivityIndicatorView;

static CGFloat const kAvatarDimension = 40.f;
static CGFloat const kStandartPadding = 8.f;
static CGFloat const kSmallPadding = 5.f;

static NSOperationQueue*  messageQueue;


@interface KGChatCommonTableViewCell : KGTableViewCell {
        NSString *_dateString;
}

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) ActiveLabel *messageLabel;
@property (nonatomic, strong) DGActivityIndicatorView *loadingView;
@property (strong, nonatomic) NSBlockOperation* messageOperation;


//@property (nonatomic, strong) UIButton *errorView;
- (void)startAnimation;
- (void)finishAnimation;
- (void)errorAction;
@end
