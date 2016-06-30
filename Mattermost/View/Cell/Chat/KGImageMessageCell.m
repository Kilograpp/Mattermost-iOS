//
//  KGImageChatCell.m
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageMessageCell.h"
#import <BOString.h>
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "UIFont+KGPreparedFont.h"
#import "KGPost.h"
#import "KGUser.h"
#import "KGFile.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSAttributedString+FormattedTitle.h"
#import "UIColor+KGPreparedColor.h"
#import "NSString+HeightCalculation.h"


static CGFloat const topPadding = 4.f;
static CGFloat const verticalPadding = 8.0f;
static CGFloat const avatarImageHeight = 40.f;
static CGFloat const horizontalPadding = 8.f;
static CGFloat const aspectRatioImage = 1.5;
static CGFloat const heightNameLabel = 22.f;

@interface KGImageMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageChatView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation KGImageMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)configure {
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    
    self.timeLabel.font = [UIFont kg_light16Font];
    self.timeLabel.textColor = [UIColor kg_grayColor];
    
    self.subtitleLabel.font = [UIFont kg_semibold16Font];
    self.subtitleLabel.textColor = [UIColor kg_blueColor];
}

- (void)configureWithObject:(KGPost *)post {
    
    self.nameLabel.text = post.author.username;
    self.timeLabel.text = [post.createdAt timeFormatForMessages];
    
    //вместо pastedImageAt - поставить название картинки
    NSString *pastedImageAt = NSLocalizedString(@"Pasted image at", nil);
    self.subtitleLabel.text = pastedImageAt;
    
    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies completed:nil
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
    
    for (KGFile *file in post.files) {
                if (file.isImage) {
                    [self.imageChatView setImageWithURL:file.thumbLink placeholderImage:nil options:SDWebImageHandleCookies completed:nil
                            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }

    }
}

+ (CGFloat)heightWithObject:(KGPost *)post {
    CGFloat heightCell = 0.f;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat labelWidht = screenWidth - horizontalPadding - avatarImageHeight - horizontalPadding - horizontalPadding;
    
    //вместо pastedImageAt - поставить название картинки
    NSString *pastedImageAt = NSLocalizedString(@"Pasted image at", nil);
    NSString *subtitleText = [NSString stringWithFormat:@"%@", pastedImageAt];
    
    CGFloat heightSubtitleText = [subtitleText heightForTextWithWidth:labelWidht withFont:[UIFont kg_semibold16Font]];
    CGFloat heightImage = labelWidht/aspectRatioImage;
    
    heightCell = topPadding + heightNameLabel + verticalPadding + heightSubtitleText + verticalPadding + heightImage + verticalPadding;
    return heightCell;
}



@end
