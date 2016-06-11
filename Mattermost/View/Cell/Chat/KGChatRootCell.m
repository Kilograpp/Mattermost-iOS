//
//  KGChatRootCell.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatRootCell.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
//#import "KGBusinessLogic+Session.h"
#import "KGPost.h"
#import "KGUser.h"
#import "UIFont+KGPreparedFont.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+HeightCalculation.h"
#import "UIColor+KGPreparedColor.h"

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
    self.nameLabel.font = [UIFont kg_semibold16Font];

}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    self.nameLabel.text = post.author.nickname;
    //KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    //self.messageLabel.backgroundColor = (post.author.identifier == user.identifier) ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
    self.dateTimeLabel.text = [post.createdAt timeFormatForMessages];
    [self.avatarImageView setImageWithURL:post.author.imageUrl
                         placeholderImage:[UIImage imageNamed:@"Icon-Small"]
                                  options:SDWebImageHandleCookies completed:nil
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
}


+ (NSString*)reuseIdentifier{
    return NSStringFromClass(self);
}

+ (CGFloat)heightWithObject:(KGPost*)post {
    CGFloat kAvatarUser = 40;
    CGFloat kGorizontalPadding = 8;
    CGFloat kVerticalPadding = 8;
    CGFloat kTopPadding = 3;
    CGFloat kNameToMessagePadding = 2;
    CGFloat kNameHeight = 22;
    CGFloat kBottomPadding = 2;
    CGFloat kMinHeightCell = kAvatarUser + kVerticalPadding*2;

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat messageLabelWidth = screenWidth - kAvatarUser - kGorizontalPadding*3;
    CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
    CGFloat heightCell = kTopPadding + kNameHeight + kNameToMessagePadding + heightMessage + kBottomPadding;
    
    return MAX(kMinHeightCell, heightCell);
}


@end
