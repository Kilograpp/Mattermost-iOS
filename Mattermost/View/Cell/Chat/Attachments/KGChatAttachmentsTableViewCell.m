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
#import "KGFileCell.h"
#import "KGUIUtils.h"
#import <UITableView_Cache/UITableView+Cache.h>
#import "UIView+Align.h"
#import "KGDrawer.h"

#define KG_CONTENT_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f
#define KG_IMAGE_HEIGHT  (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.56f
#define KG_FILE_HEIGHT  56.f

@interface KGChatAttachmentsTableViewCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
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

//
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    CGFloat bottomYCoordOfMessage =
//    ceilf(self.messageLabel.frame.size.width) > 0 ? self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height :
//    self.messageLabel.frame.origin.y;
//    CGFloat xCoordOfMessage = self.messageLabel.frame.origin.x;
//    CGPoint offset = (CGPoint){xCoordOfMessage, bottomYCoordOfMessage + 8};
//    for (KGFile *file in self.files) {
//        if ([file isImage]){
//            [[KGDrawer sharedInstance] drawImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:file.thumbLink.absoluteString] inRect:CGRectOffset(rect, offset.x, offset.y)];
//            offset.y += KG_IMAGE_HEIGHT;
//        } else {
//            [[KGDrawer sharedInstance] drawFile:file inRect:CGRectOffset(rect, offset.x, offset.y)];
//            offset.y += KG_FILE_HEIGHT;
//        }
//    }
//
//}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.scrollsToTop = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.layer.drawsAsynchronously = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.tableView];
    
    [self.tableView registerClass:[KGImageCell class] forCellReuseIdentifier:[KGImageCell reuseIdentifier] cacheSize:5];
    [self.tableView registerClass:[KGFileCell class] forCellReuseIdentifier:[KGFileCell reuseIdentifier] cacheSize:5];
    self.backgroundColor = [UIColor kg_whiteColor];
}

- (void)setupErrorView {
    self.errorView = [[UIButton alloc] init];
    [self.errorView setImage:[UIImage imageNamed:@"chat_file_ic"] forState:UIControlStateNormal];
    [self.errorView addTarget:self action:@selector(errorAction) forControlEvents:UIControlEventTouchUpInside];
    self.errorView.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
}
#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    NSAssert([object isKindOfClass:[KGPost class]],  @"Object must be KGPost class at KGChatAttachmentsTableViewCell's configureWithObject method!");
    [super configureWithObject:object];
    self.files = [self.post sortedFiles];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        __weak typeof(self) wSelf = self;
//        
//        for (KGFile* file in self.files) {
//            
//            if (file.isImage){
//                if (![[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:file.thumbLink.absoluteString]) {
//                    [[SDWebImageManager sharedManager] downloadImageWithURL:file.thumbLink options:SDWebImageHandleCookies progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        
//                        CGFloat scaleFactor = KG_IMAGE_HEIGHT / image.size.height;
//                        
//                        CGSize imageSize = CGSizeMake(image.size.width * scaleFactor, image.size.height * scaleFactor);
//                        
//                        [UIImage roundedImage:image
//                                  whithRadius:3
//                                         size:imageSize
//                                   completion:^(UIImage *image) {
//                                       //[wSelf setNeedsLayout];
//                                       
//                                       [[SDImageCache sharedImageCache] storeImage:image forKey:file.thumbLink.absoluteString];
//                                       [wSelf setNeedsDisplay];
//                                   }];
//                        
//                        
//                    }];
//                    
//                }
//            }
//        }
//        
//        
//    });

   
    [self.tableView reloadData];
    self.backgroundColor = self.post.isUnread ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    NSAssert([object isKindOfClass:[KGPost class]],  @"Object must be KGPost class at KGChatAttachmentsTableViewCell's heightWithObject method!");

    KGPost *post = object;
    CGFloat heightCell = [super heightWithObject:object];
    heightCell += tableViewHeight(post.files.allObjects);
    return  ceilf(heightCell + 8);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.files[indexPath.row] isImage]){
        KGImageCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGImageCell reuseIdentifier]];
    
        KGFile *file = self.files[indexPath.row];
        [cell configureWithObject:file];
        return cell;
    } else {
        KGFileCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGFileCell reuseIdentifier]];
        KGFile *file = self.files[indexPath.row];
        
        [cell configureWithObject:file];
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.files[indexPath.row] isImage]){
        return ceilf(KG_IMAGE_HEIGHT);
    }
    return ceilf(KG_FILE_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KGFile *file = self.files[indexPath.row];
    
    if (file.isImage) {
        if (self.photoTapHandler) {
            self.photoTapHandler(indexPath.row, ((KGImageCell *)[self.tableView cellForRowAtIndexPath:indexPath]));
        }
    } else {
        if (self.fileTapHandler) {
            self.fileTapHandler(indexPath.row);
        }
    }
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bottomYCoordOfMessage =
            ceilf(self.messageLabel.frame.size.width) > 0 ? self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height :
                                                            self.messageLabel.frame.origin.y;
    CGFloat xCoordOfMessage = self.messageLabel.frame.origin.x;
    CGFloat width = KGScreenWidth() - 61;
    
    self.tableView.frame = CGRectMake(xCoordOfMessage, bottomYCoordOfMessage + 8, width, self.tableView.frame.size.height);
    
    [self alignSubviews];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

CGFloat tableViewHeight(NSArray *files) {
    
    CGFloat heightImage = 0;
    for (KGFile *file in files) {
        if ([file isImage]){
            heightImage +=  KG_IMAGE_HEIGHT;
        } else {
            heightImage +=  KG_FILE_HEIGHT;
        }
    }

    return heightImage;
}

@end
