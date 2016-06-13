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
#import "SDWebImageDownloader.h"

@interface KGChatRootCell ()
@property (weak, nonatomic) IBOutlet ActiveLabel* messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@end

@implementation KGChatRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}


#pragma mark - Setup

- (void)setup {
    [self.messageLabel setFont:[UIFont kg_regular15Font]];
    [self.messageLabel setMentionColor:[UIColor blueColor]];
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateTimeLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateTimeLabel.font = [UIFont kg_regular13Font];
    [self.messageLabel setBackgroundColor:[UIColor kg_whiteColor]];
    self.avatarImageView.backgroundColor = [UIColor kg_whiteColor];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously = YES;
    
    self.messageLabel.layer.drawsAsynchronously = YES;
    
    self.avatarImageView.layer.drawsAsynchronously = YES;
    self.avatarImageView.layer.cornerRadius = 20.f;
    self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
}


#pragma mark - Configuration

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    self.nameLabel.text = post.author.nickname;
    self.dateTimeLabel.text = [post.createdAt timeFormatForMessages];

    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:[[self class] placeholderImage] options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.avatarImageView removeActivityIndicator];
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        CGFloat kAvatarUser = 40;
        CGFloat kGorizontalPadding = 8;
        CGFloat kTopPadding = 16;
        CGFloat kNameToMessagePadding = 2;
        CGFloat kNameHeight = 22;
        CGFloat kBottomPadding = 2;
//        CGFloat kMinHeightCell = kAvatarUser + kVerticalPadding*2;
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat messageLabelWidth = screenWidth - kAvatarUser - kGorizontalPadding*3;
        CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
        CGFloat heightCell = kTopPadding + kNameHeight + kNameToMessagePadding + heightMessage + kBottomPadding;
        
        return  ceilf(heightCell);
    }
    
    return 0.f;
}

+ (UIImage *)placeholderImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
//                                   [[UIColor lightGrayColor] CGColor]);
      [[UIColor colorWithRed:232./255 green:237./255 blue: 239./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
