//
//  IVManualCell.m
//  SkillTest
//
//  Created by Igor Vedeneev on 25.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "IVManualCell.h"
#import "KGPost.h"
#import "UIImage+Resize.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGUser.h"
#import "NSDate+DateFormatter.h"
#import <ActiveLabel/ActiveLabel-Swift.h>

#define KG_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

static NSOperationQueue*  messageQueue;
//static NSOperationQueue*  imageQueue;

@interface IVManualCell () {
    CGRect _msgRect;
    NSString *_dateString;
}
@property (nonatomic, strong) ActiveLabel *messageLabel;
//@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (strong, nonatomic) NSBlockOperation* messageOperation;
//@property (strong, nonatomic) NSBlockOperation* imageOperation;
@property (nonatomic, strong) KGPost *post;
@end

@implementation IVManualCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setup];
        [self setupNameLabel];
        [self setupTextLabel];
        [self setupImageView];
        [self setupTimeLabel];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (void)load {
    messageQueue = [[NSOperationQueue alloc] init];
    [messageQueue setMaxConcurrentOperationCount:1];
    
//    imageQueue = [[NSOperationQueue alloc] init];
//    [imageQueue setMaxConcurrentOperationCount:1];
}

- (void)setupTextLabel {
    _messageLabel = [[ActiveLabel alloc] initWithFrame:CGRectZero];
//    _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _messageLabel.numberOfLines = 0;
    _messageLabel.backgroundColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont kg_regular15Font];
    _messageLabel.textColor = [UIColor kg_blackColor];
    [self addSubview:_messageLabel];
    
    [_messageLabel setURLColor:[UIColor kg_blueColor]];
    [_messageLabel setURLSelectedColor:[UIColor blueColor]];
    [_messageLabel setMentionSelectedColor:[UIColor blueColor]];
    [_messageLabel setHashtagColor:[UIColor kg_greenColorForAlert]];
    [_messageLabel setMentionColor:[UIColor kg_blueColor]];
    
    _messageLabel.layer.shouldRasterize = YES;
    _messageLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    _messageLabel.layer.drawsAsynchronously = YES;
}

- (void)setupNameLabel {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _nameLabel.numberOfLines = 1;
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont kg_semibold16Font];
    _nameLabel.textColor = [UIColor kg_blackColor];
    [self addSubview:_nameLabel];
}

- (void)setupTimeLabel {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _timeLabel.numberOfLines = 1;
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont kg_regular13Font];
    _timeLabel.textColor = [UIColor kg_lightGrayColor];
    [self addSubview:_timeLabel];
}

- (void)setupImageView {
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
//    _avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _avatarImageView.image = KGRoundedPlaceholderImage(CGSizeMake(40.f, 40.f));
    [self addSubview:_avatarImageView];
}

- (void)configureWithObject:(id)object {
    _post = object;

    __weak typeof(self) wSelf = self;

    self.messageOperation = [[NSBlockOperation alloc] init];
    [self.messageOperation addExecutionBlock:^{
        if (!wSelf.messageOperation.isCancelled) {
            dispatch_sync(dispatch_get_main_queue(), ^(void)
            {
                wSelf.messageLabel.text = wSelf.post.message;
            });
        }
    }];
    [messageQueue addOperation:self.messageOperation];


    _nameLabel.text = _post.author.nickname;
    _dateString = [_post.createdAt dateFormatForMassage];
    _timeLabel.text = _dateString;
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.post.author.imageUrl.absoluteString];
    if (cachedImage) {
        wSelf.avatarImageView.image = KGRoundedImage(cachedImage, CGSizeMake(40, 40));
    } else {
        [self.avatarImageView setImageWithURL:self.post.author.imageUrl
                             placeholderImage:KGRoundedPlaceholderImage(CGSizeMake(40.f, 40.f))
                                      options:SDWebImageHandleCookies
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        wSelf.avatarImageView.image = KGRoundedImage(image, CGSizeMake(40, 40));
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.avatarImageView removeActivityIndicator];
    }

}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textWidth = KG_SCREEN_WIDTH - 61.f;
    self.backgroundColor = [UIColor kg_whiteColor];
    
    _msgRect = [_post.message boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{ NSFontAttributeName : [UIFont kg_regular15Font] }
                                            context:nil];
    
    CGFloat nameWidth = [[self class] widthOfString:_post.author.nickname withFont:[UIFont kg_semibold16Font]];
    CGFloat timeWidth = [[self class] widthOfString:_dateString withFont:[UIFont kg_regular13Font]];
    _messageLabel.frame = CGRectMake(53, 36, ceilf(_msgRect.size.width), ceilf(_msgRect.size.height));
    _nameLabel.frame = CGRectMake(53, 8, nameWidth, 20);
    _timeLabel.frame = CGRectMake(_nameLabel.frame.origin.x + nameWidth + 5, 8, ceilf(timeWidth), 20);
}

+ (CGFloat)heightWithObject:(id)object {
    KGPost *adapter = object;
    CGFloat textWidth = KG_SCREEN_WIDTH - 61.f;
    CGRect msg = [adapter.message boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName : [UIFont kg_regular15Font] }
                                              context:nil];


    return ceilf(msg.size.height) + 24 + 20;
}


+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    return  ceilf([[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
}


- (void)prepareForReuse {
    _avatarImageView.image = KGRoundedPlaceholderImage(CGSizeMake(40.f, 40.f));
    _messageLabel.text = nil;
    [_messageOperation cancel];
}
@end
