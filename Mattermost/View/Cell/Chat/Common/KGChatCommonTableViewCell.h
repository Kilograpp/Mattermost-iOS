//
//  KGChatCommonTableViewCell.h
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
@class ActiveLabel, ASNetworkImageNode;

static CGFloat const kAvatarDimension = 40.f;
static CGFloat const kStandartPadding = 8.f;
static CGFloat const kSmallPadding = 5.f;
@interface KGChatCommonTableViewCell : KGTableViewCell


@property (nonatomic, strong) ASNetworkImageNode *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) ActiveLabel *messageLabel;

@end
