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
#import "UIImage+Resize.h"
#import "KGPreferences.h"
#import "KGUser.h"

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
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateTimeLabel.backgroundColor = [UIColor kg_whiteColor];
    self.dateTimeLabel.font = [UIFont kg_regular13Font];
    [self.messageLabel setBackgroundColor:[UIColor kg_whiteColor]];
    self.avatarImageView.backgroundColor = [UIColor kg_whiteColor];
    [self.messageLabel setURLColor:[UIColor kg_blueColor]];
    [self.messageLabel setHashtagColor:[UIColor kg_greenColorForAlert]];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
   
//    [self.messageLabel filterMention:^BOOL(NSString * nameString) {
//        NSString *stringCurrentUserId = [[KGPreferences sharedInstance]currentUserId];
//        KGUser *user = [KGUser managedObjectById:stringCurrentUserId];
//        
//        if ([nameString isEqualToString:@"channel"] || [nameString isEqualToString:@"all"]
//            || [nameString isEqualToString:user.nickname]) {
//            return YES;
//        } else {
//            [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
//            return YES;
//        }
//    }];

    
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously = YES;
    
    for (UIView *v in self.subviews){
        v.layer.shouldRasterize = YES;
        v.layer.rasterizationScale = [UIScreen mainScreen].scale;
        v.layer.drawsAsynchronously = YES;
    }
    
    self.messageLabel.layer.drawsAsynchronously = YES;
    
    self.avatarImageView.layer.drawsAsynchronously = YES;
    self.avatarImageView.layer.cornerRadius = 20.f;
    self.avatarImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
}


#pragma mark - Configuration

//- (void)configureWithObject:(KGPost*)post {
//    self.messageLabel.text = post.message;
//    self.nameLabel.text = post.author.nickname;
//    self.dateTimeLabel.text = [post.createdAt timeFormatForMessages];
//
//    [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:[[self class] placeholderImage] options:SDWebImageHandleCookies
//              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    [self.avatarImageView removeActivityIndicator];
//}
- (void)configureWithObject:(KGPost*)post {
//    if ([object isKindOfClass:[KGPost class]]) {
//        KGPost *post = object;
    
    
    
        self.messageLabel.text = post.message;
        self.nameLabel.text = post.author.nickname;
        self.dateTimeLabel.text = [post.createdAt timeFormatForMessages];
        //        self.avatarImageView.URL = post.author.imageUrl;
        //        self.avatarImageView.layerBacked = YES;
        
        for (UIView *view in self.subviews) {
            view.backgroundColor = post.identifier ? [UIColor kg_whiteColor] : [UIColor colorWithWhite:0.95f alpha:1.f];
        }
//        dispatch_queue_t bgQueue = dispatch_get_global_queue(0, 0);
//        __weak typeof(self) wSelf = self;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:post.author.imageUrl.absoluteString];
        if (cachedImage) {
            [[self class] roundedImage:cachedImage completion:^(UIImage *image) {
                self.avatarImageView.image = image;
                //                [self.avatarImageView setNeedsDisplay];
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
        
        //        [self.avatarImageView setImageWithURL:post.author.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
        //                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   // }
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
