//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGFollowUpChatCell.h"
#import "UIFont+KGPreparedFont.h"
#import "KGPost.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "UIColor+KGPreparedColor.h"
#import "NSString+HeightCalculation.h"

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
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
    self.messageLabel.layer.drawsAsynchronously = YES;
    self.messageLabel.layer.shouldRasterize = YES;
    self.messageLabel.backgroundColor = [UIColor kg_whiteColor];
}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    
    for (UIView *view in self.subviews) {
        view.backgroundColor = post.identifier ? [UIColor kg_whiteColor] : [UIColor colorWithWhite:0.95f alpha:1.f];
        self.messageLabel.backgroundColor = post.identifier ? [UIColor kg_whiteColor] : [UIColor colorWithWhite:0.95f alpha:1.f];
    }
}

+ (CGFloat)heightWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        CGFloat verticalPaddings = 16.f;
        CGFloat horizontalPaddings = 61.f;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat messageLabelWidth = screenWidth - horizontalPaddings;
        CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
        CGFloat heightCell = heightMessage + verticalPaddings;
        
        return  ceilf(heightCell);
    }
    
    return 0.f;
}

@end