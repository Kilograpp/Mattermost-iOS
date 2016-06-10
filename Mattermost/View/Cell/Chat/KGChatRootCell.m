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
#import "KGPost.h"
#import "KGUser.h"
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
    [self.messageLabel setMentionColor:[UIColor blueColor]];

}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    self.nameLabel.text = post.author.username;
    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies completed:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
}

+ (NSString*)reuseIdentifier{
    return NSStringFromClass(self);
}

+ (CGFloat)heightWithObject:(KGPost*)post {
    
    NSInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger messageLabelWidth = screenWidth - 45 - 8 - 8 - 8;
    
    NSAttributedString* messageAttributedString = [post.message bos_makeString:^(BOStringMaker *make) {
        make.font([UIFont kg_regular15Font]);
    }];
    
    CGRect rect = [messageAttributedString boundingRectWithSize:CGSizeMake(messageLabelWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height + 22 + 2;

}

@end
