//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
#import "KGUIUtils.h"
@class ActiveLabel, KGPost;

static NSOperationQueue*  messageQueue;

@interface KGFollowUpChatCell : KGTableViewCell {
    CGRect _msgRect;
    NSString *_dateString;
}

@property (nonatomic, strong) ActiveLabel *messageLabel;
@property (strong, nonatomic) NSBlockOperation* messageOperation;
@property (nonatomic, strong) KGPost *post;

@end