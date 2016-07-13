//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
#import "KGUIUtils.h"
@class ActiveLabel, KGPost,DGActivityIndicatorView;

static NSOperationQueue*  messageQueue;
//static CGFloat const kStandartPadding = 8.f;
@interface KGFollowUpChatCell : KGTableViewCell {
    NSString *_dateString;
}

@property (nonatomic, strong) ActiveLabel *messageLabel;
@property (strong, nonatomic) NSBlockOperation* messageOperation;
@property (nonatomic, strong) DGActivityIndicatorView *loadingView;
//@property (nonatomic, strong) UIButton *errorView;



@end