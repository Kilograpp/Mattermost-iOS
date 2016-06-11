//
//  KGChatRootCell.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatRootCell.h"
#import <BOString.h>
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGPost.h"
#import "KGUser.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface KGChatRootCell ()
@property (weak, nonatomic) IBOutlet ActiveLabel* messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@end

@implementation KGChatRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)configure {
    [self.messageLabel setFont:[UIFont kg_regular15Font]];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];

}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    self.nameLabel.text = post.author.username;
    self.dateTimeLabel.text = [post.createdAt timeFormatForMessages];
    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies completed:nil
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
}


+ (NSString*)reuseIdentifier{
    return NSStringFromClass(self);
}

+ (CGFloat)heightWithObject:(KGPost*)post {

    NSInteger kTopPadding = 5;
    NSInteger kNameToMessagePadding = 2;
    NSInteger kNameHeight = 22;
    NSInteger kBottomPadding = 2;

    NSInteger screenWidth = (NSInteger) [[UIScreen mainScreen] bounds].size.width;
    NSInteger messageLabelWidth = screenWidth - 45 - 8 - 8 - 8;

    NSAttributedString* messageAttributedString = [post.message bos_makeString:^(BOStringMaker *make) {
        make.font([UIFont kg_regular15Font]);
    }];

    CGRect rect = [messageAttributedString boundingRectWithSize:CGSizeMake(messageLabelWidth, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        context:nil];

    return rect.size.height + kNameHeight + kTopPadding + kNameToMessagePadding + kBottomPadding;

}


@end
