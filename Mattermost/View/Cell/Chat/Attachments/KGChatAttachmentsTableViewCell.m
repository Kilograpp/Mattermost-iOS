//
//  KGChatAttachmentsTableViewCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatAttachmentsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "KGPost.h"
#import "KGUser.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+HeightCalculation.h"
#import "KGImageCell.h"
#import "KGFile.h"
#import "UIImage+Resize.h"

#define KG_CONTENT_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.66f

@interface KGChatAttachmentsTableViewCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KGPost *post;
@property (nonatomic, copy)   NSArray *files;
@end

@implementation KGChatAttachmentsTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupTableView];
    }
    
    return self;
}



#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.scrollsToTop = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.layer.drawsAsynchronously = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_leading);
        make.trailing.equalTo(self).offset(-kStandartPadding);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.messageLabel);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(kStandartPadding);
        make.bottom.equalTo(self).offset(-kStandartPadding);
    }];
    
    [self.tableView registerClass:[KGImageCell class] forCellReuseIdentifier:[KGImageCell reuseIdentifier]];
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;
        
        self.post = post;
        self.nameLabel.text = post.author.username;
        self.dateLabel.text = [post.createdAt timeFormatForMessages];
//        self.messageLabel.text = post.message;
        self.messageLabel.text = @"attacments";
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:post.author.imageUrl.absoluteString];
        
        if (cachedImage) {
            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
                self.avatarImageView.image = image;
            }];
        } else {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:post.author.imageUrl
                                                                  options:SDWebImageDownloaderHandleCookies
                                                                 progress:nil
                 completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                     [[self class] roundedImage:image completion:^(UIImage *image) {
                         [[SDImageCache sharedImageCache] storeImage:image forKey:post.author.imageUrl.absoluteString];
                         self.avatarImageView.image = image;
                     }];
                 }];
            [self.avatarImageView removeActivityIndicator];
        }
        
        self.messageLabel.text = post.message;
        //FIXME: Добавить деление файл - не файл и наличие заголовка
        self.files = [[post.files allObjects] sortedArrayUsingSelector:@selector(name)];
        
        [self.tableView reloadData];
    }
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        KGPost *post = object;

        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat messageLabelWidth = screenWidth - kAvatarDimension - kStandartPadding * 2 - kSmallPadding;
        CGFloat heightMessage = [post.message heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_regular15Font]];
        CGFloat nameMessage = [post.author.nickname heightForTextWithWidth:messageLabelWidth withFont:[UIFont kg_semibold16Font]];
        CGFloat heightCell = kStandartPadding + nameMessage + kSmallPadding + heightMessage + kStandartPadding + kStandartPadding;
        
        CGFloat heightImage = post.files.count * KG_IMAGE_HEIGHT;
        heightCell += heightImage;
        
        return ceilf(heightCell);
    }
    
    return 0.f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGImageCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGImageCell reuseIdentifier] forIndexPath:indexPath];
    
    KGFile *file = self.files[indexPath.row];
    [cell configureWithObject:file];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ceilf(KG_IMAGE_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.photoTapHandler) {
        self.photoTapHandler(indexPath.row, ((KGImageCell *)[self.tableView cellForRowAtIndexPath:indexPath]).kg_imageView);
    }
}

@end
