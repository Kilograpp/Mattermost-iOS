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

@interface IVManualCell () {
    CGRect _msgRect;
    NSString *_dateString;
}
@property (nonatomic, strong) ActiveLabel *messageLabel;
//@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) KGPost *post;
@end

@implementation IVManualCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
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
//    _avatarImageView.layer.cornerRadius = 20;
//    _avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _avatarImageView.clipsToBounds = YES;
    [self addSubview:_avatarImageView];
}

- (void)configureWithObject:(id)object {
    _post = object;
    _messageLabel.text = _post.message;
    _nameLabel.text = _post.author.nickname;
    _dateString = [_post.createdAt dateFormatForMassage];
    _timeLabel.text = _dateString;
//    _avatarImageView.image =  KGRoundedImage([UIImage imageNamed:@"k132h3.jpg"], CGSizeMake(40.f, 40.f));
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:_post.author.imageUrl
                                                          options:SDWebImageDownloaderHandleCookies
                                                         progress:nil
            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                _avatarImageView.image = KGRoundedImage(image, CGSizeMake(40.f, 40.f));
            }];
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
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return  ceilf([[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
}


- (void)prepareForReuse {
    _avatarImageView.image = nil;
    _avatarImageView.image = KGRoundedPlaceholderImage(CGSizeMake(40.f, 40.f));
}
@end
