//
//  KGChatCommonTableViewCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatCommonTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "KGPost.h"
#import "KGUser.h"
#import "NSDate+DateFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+HeightCalculation.h"
#import "UIImage+Resize.h"
#import "KGPreferences.h"
#import <DGActivityIndicatorView.h>
#import "UIView+Align.h"

static CGFloat const kLoadingViewSize = 20.f;
static CGFloat const kErrorViewSize = 34.f;


@implementation KGChatCommonTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        [self setupAvatarImageView];
       
        [self setupMessageLabel];
        [self setupNameLabel];
        [self setupDateLabel];
        [self setupLoadingView];
        [self setupErrorView];
    }
    
    return self;
}

+ (void)load {
    messageQueue = [[NSOperationQueue alloc] init];
    [messageQueue setMaxConcurrentOperationCount:1];
}


#pragma mark - Setup

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupAvatarImageView {
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.avatarImageView];
    [self.avatarImageView setUserInteractionEnabled:YES];
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProfileAction)]];
}

- (void)setupNameLabel {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont kg_semibold16Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    [self addSubview:self.nameLabel];
    [self.nameLabel setUserInteractionEnabled:YES];
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProfileAction)]];

}

- (void)setupDateLabel {
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.dateLabel.numberOfLines = 1;
    self.dateLabel.backgroundColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont kg_regular13Font];
    self.dateLabel.textColor = [UIColor kg_lightGrayColor];
    [self addSubview:self.dateLabel];
}

- (void)setupMessageLabel {
    self.messageLabel = [[ActiveLabel alloc] init];
    self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.backgroundColor = [UIColor whiteColor];
    self.messageLabel.font = [UIFont kg_regular15Font];
    self.messageLabel.textColor = [UIColor kg_blackColor];
    [self addSubview:self.messageLabel];
    
    [self.messageLabel setURLColor:[UIColor kg_blueColor]];
    [self.messageLabel setURLSelectedColor:[UIColor blueColor]];
    [self.messageLabel setMentionSelectedColor:[UIColor blueColor]];
    [self.messageLabel setHashtagColor:[UIColor kg_greenColorForAlert]];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
    
    self.messageLabel.preferredMaxLayoutWidth = 200.f - kLoadingViewSize;

    [self.messageLabel handleMentionTap:^(NSString *string) {
        self.mentionTapHandler(string);
    }];
    [self.messageLabel handleURLTap:^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
}

- (void)setupLoadingView {
    self.loadingView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse
                                                          tintColor:[UIColor kg_blueColor]
                                                               size:kLoadingViewSize - kSmallPadding];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.loadingView];
}

- (void)setupErrorView {
    self.errorView = [[UIButton alloc] init];
    [self.errorView setImage:[UIImage imageNamed:@"message_fail_button"] forState:UIControlStateNormal];
    [self.errorView addTarget:self action:@selector(errorAction) forControlEvents:UIControlEventTouchUpInside];
    self.errorView.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [self addSubview:self.errorView];
    self.errorView.hidden = YES;
}

#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGPost class]]) {
        self.post = object;
        
        __weak typeof(self) wSelf = self;
        
        self.messageOperation = [[NSBlockOperation alloc] init];
        [self.messageOperation addExecutionBlock:^{
            if (!wSelf.messageOperation.isCancelled) {
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    wSelf.messageLabel.attributedText = wSelf.post.attributedMessage;
              });
            }
        }];
        [messageQueue addOperation:self.messageOperation];
        
        self.nameLabel.text = self.post.author.nickname;
        _dateString = [self.post.createdAt timeFormatForMessages];
        self.dateLabel.text = _dateString;

        
        
        __block NSString* smallAvatarKey = [self.post.author.imageUrl.absoluteString stringByAppendingString:@"_feed"];
        UIImage* smallAvatar = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:smallAvatarKey];
        
        if (!smallAvatar && [[SDImageCache sharedImageCache] diskImageExistsWithKey:smallAvatarKey]) {
            smallAvatar = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallAvatarKey];
            self.avatarImageView.image = smallAvatar;
        } else {
            [self.avatarImageView setImageWithURL:self.post.author.imageUrl
                                 placeholderImage:KGRoundedPlaceholderImage(CGSizeMake(40, 40))
                                          options:SDWebImageHandleCookies | SDWebImageAvoidAutoSetImage
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            
                                            UIImage* roundedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:smallAvatarKey];
                                            
                                            if (!roundedImage) {
                                                roundedImage = KGRoundedImage(image, CGSizeMake(40, 40));
                                                [[SDImageCache sharedImageCache] storeImage:roundedImage forKey:smallAvatarKey];
                                                
                                            } 
                                            
                                            wSelf.avatarImageView.image = roundedImage;
                                        }
                      usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.avatarImageView removeActivityIndicator];
        }
        
        
        
        

        if (self.post.error){
            [self showError];
        } else {
            if (!self.post.identifier) {
                [self startAnimation];
            } else {
                [self finishAnimation];
            }
        }
    }
}

- (void)showError {
    self.errorView.hidden = NO;
    self.loadingView.hidden = YES;
}

- (void)hideError {
    self.errorView.hidden = YES;
}

- (void)startAnimation {
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
}

- (void)finishAnimation {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textWidth = KGScreenWidth() - 61.f;
    self.backgroundColor = [UIColor kg_whiteColor];
    self.messageLabel.backgroundColor = [UIColor kg_whiteColor];
    
    CGFloat nameWidth = [[self class] widthOfString:self.post.author.nickname withFont:[UIFont kg_semibold16Font]];
    CGFloat timeWidth = [[self class] widthOfString:_dateString withFont:[UIFont kg_regular13Font]];
    self.messageLabel.frame = CGRectMake(53, 36, textWidth - kLoadingViewSize, self.post.heightValue);
    self.nameLabel.frame = CGRectMake(53, 8, nameWidth, 20);
    self.dateLabel.frame = CGRectMake(_nameLabel.frame.origin.x + nameWidth + 5, 8, timeWidth, 20);
    self.loadingView.frame = CGRectMake(KGScreenWidth() - kLoadingViewSize - kStandartPadding, 36, kLoadingViewSize, 20);
    self.errorView.frame = CGRectMake(KGScreenWidth() - kErrorViewSize ,(self.frame.size.height - kErrorViewSize)/2 ,kErrorViewSize ,kErrorViewSize);
    
    [self alignSubviews];
}

+ (CGFloat)heightWithObject:(id)object {
    KGPost *adapter = object;
    return adapter.heightValue + 24 + 20;
}


+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string) {
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        return  ceilf([[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
    }
    
    return 0.00001;
}


- (void)prepareForReuse {
    _avatarImageView.image = nil;//KGRoundedPlaceholderImage(CGSizeMake(40.f, 40.f));
    _messageLabel.text = nil;
    [_messageOperation cancel];
    _loadingView.hidden = YES;
    self.errorView.hidden = YES;
}

- (void)errorAction {
    if (self.errorTapHandler) {
        //        self.photoTapHandler(indexPath.row, ((KGImageCell *)[self.tableView cellForRowAtIndexPath:indexPath]).kg_imageView);
        self.errorTapHandler(self.post);
    }
    
}

- (void)showProfileAction {
    if (self.profileTapHandler) {
        //        self.photoTapHandler(indexPath.row, ((KGImageCell *)[self.tableView cellForRowAtIndexPath:indexPath]).kg_imageView);
        self.profileTapHandler(self.post.author);
    }
}
@end
