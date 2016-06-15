//
//  KGImageChatCell.m
//  Mattermost
//
//  Created by Mariya on 10.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageChatCell.h"
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
#import "KGImageCell.h"

//static CGFloat const topPadding = 4.f;
//static CGFloat const verticalPadding = 8.0f;
//static CGFloat const avatarImageHeight = 40.f;
//static CGFloat const horizontalPadding = 8.f;
//static CGFloat const aspectRatioImage = 1.5;
//static CGFloat const heightNameLabel = 22.f;

#define KG_CONTENT_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.5f
static CGFloat const kCellAspectRatio = 0.5f;
static NSString *const kImageCellReuseIdentifier = @"cellReuseIdentifier";

@interface KGImageChatCell () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) KGPost *post;
@property (nonatomic, copy) NSArray *files;
@end

@implementation KGImageChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)configure {
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    
    self.timeLabel.font = [UIFont kg_regular13Font];
    self.timeLabel.textColor = [UIColor kg_grayColor];
    
    self.subtitleLabel.font = [UIFont kg_regular15Font];
    self.subtitleLabel.textColor = [UIColor kg_blueColor];
    
    self.tableView.scrollsToTop = NO;
    self.tableView.layer.drawsAsynchronously = YES;
    
    self.avatarImageView.layer.drawsAsynchronously = YES;
    self.avatarImageView.layer.cornerRadius = 20.f;
    self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
    
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.timeLabel.backgroundColor = [UIColor kg_whiteColor];
    self.subtitleLabel.backgroundColor = [UIColor kg_whiteColor];
    
    [self.tableView registerClass:[KGImageCell class] forCellReuseIdentifier:kImageCellReuseIdentifier];
}

- (void)configureWithObject:(KGPost *)post {
    self.post = post;
    self.nameLabel.text = post.author.username;
    self.timeLabel.text = [post.createdAt timeFormatForMessages];
    
//    //вместо pastedImageAt - поставить название картинки
//    NSString *pastedImageAt = NSLocalizedString(@"Pasted image at", nil);
//    self.subtitleLabel.text = pastedImageAt;
    
    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies completed:nil
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
    self.subtitleLabel.text = post.message;

    self.files = [[post.files allObjects] sortedArrayUsingSelector:@selector(name)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self.tableView reloadData];
}

+ (CGFloat)heightWithObject:(KGPost *)post {
    CGFloat heightCell = 0.f;
    CGFloat labelWidht = KG_CONTENT_WIDTH;//screenWidth - horizontalPadding - avatarImageHeight - horizontalPadding - horizontalPadding;
    
    NSString *subtitleText = post.message;
    CGFloat heightSubtitleText = [subtitleText heightForTextWithWidth:labelWidht withFont:[UIFont kg_regular15Font]];
    
    CGFloat heightImage = post.files.count * KG_IMAGE_HEIGHT;
    
    heightCell = 32.f + heightSubtitleText + heightImage;
    
    return ceilf(heightCell);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.post.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellReuseIdentifier];
    if (!cell) {
        cell = [[KGImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kImageCellReuseIdentifier];
    }

    
    
    
    KGFile *file = self.files[indexPath.row];
    
    if (file.isImage) {
//        NSURL *test = [NSURL URLWithString:@"http://dressacat.com/chat.png"];
        NSLog(@"%@", file.downloadLink.absoluteString);
//        [cell.kg_imageView setImageWithURL:file.downloadLink placeholderImage:nil options:SDWebImageHandleCookies completed:nil
//                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [cell.kg_imageView removeActivityIndicator];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KG_IMAGE_HEIGHT;
}


@end
