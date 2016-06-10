//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGFollowUpChatCell.h"
#import "UIFont+KGPreparedFont.h"
#import "KGPost.h"
#import <ActiveLabel/ActiveLabel-Swift.h>

@interface KGFollowUpChatCell ()
@property (weak, nonatomic) IBOutlet ActiveLabel *messageLabel;

@end

@implementation KGFollowUpChatCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)configure {
    [self.messageLabel setFont:[UIFont kg_regular15Font]];
    [self.messageLabel setMentionColor:[UIColor blueColor]];
    
}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
}



@end