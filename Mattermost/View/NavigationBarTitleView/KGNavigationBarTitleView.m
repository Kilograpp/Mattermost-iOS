//
//  KGNavigationBarTitleView.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGNavigationBarTitleView.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGUser.h"
#import "KGChannel.h"
#import "NSString+HeightCalculation.h"
#import "UIView+Align.h"
#import <DGActivityIndicatorView.h>

@interface KGNavigationBarTitleView ()
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) DGActivityIndicatorView *loadingView;
@end

@implementation KGNavigationBarTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self setupStatusView];
        [self setupTitleLabel];
        [self setupLoadingView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat xPos = 8;
    CGFloat yPos = CGRectGetHeight(self.bounds) / 2 - 2;
    self.statusIndicatorView.frame = CGRectMake(xPos, yPos, 8, 8);
    
    CGFloat titleXPos =
            self.channel.type == KGChannelTypePrivate ? CGRectGetMaxX(self.statusIndicatorView.frame) + 8 : 8;
    CGFloat titleHeight = [@"A" kg_heightForTextWidth:50 font:[UIFont kg_semibold18Font]];
    CGFloat titleYPos = CGRectGetHeight(self.bounds) / 2 - titleHeight / 2;
    CGFloat titleWidth = [[self class] widthOfString:self.titleString font:[UIFont kg_semibold18Font]];
    CGFloat availableWidthForTitle =
            self.channel.type == KGChannelTypePrivate ? CGRectGetWidth(self.bounds) - 42 :  CGRectGetWidth(self.bounds) - 26;
    titleWidth = MIN(availableWidthForTitle, titleWidth);
    self.titleLabel.frame = CGRectMake(titleXPos, titleYPos, titleWidth, titleHeight);
    self.loadingView.center = self.statusIndicatorView.center;
    
    [self alignSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGRect disclosureRect = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 4, CGRectGetHeight(rect) / 2 - 1, 8, 5);
    CGContextMoveToPoint   (ctx, CGRectGetMaxX(disclosureRect), CGRectGetMinY(disclosureRect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMinX(disclosureRect), CGRectGetMinY(disclosureRect));  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMidX(disclosureRect), CGRectGetMaxY(disclosureRect));  // bottom left
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor kg_lightGrayColor] CGColor]);
    CGContextFillPath(ctx);
}


#pragma mark - Setup

- (void)setup {
    self.backgroundColor = [UIColor kg_navigationBarTintColor];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor kg_blackColor];
    self.titleLabel.font = [UIFont kg_semibold18Font];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setupStatusView {
    self.statusIndicatorView = [[UIView alloc] init];
    [self addSubview:self.statusIndicatorView];
    self.statusIndicatorView.layer.cornerRadius = 4;
}

- (void)setupLoadingView {
    self.loadingView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleMultiple
                                                           tintColor:[UIColor kg_sectionColorLeftMenu]
                                                                size:12];
    self.loadingView.type = DGActivityIndicatorAnimationTypeTwoDots;
    self.loadingView.type = DGActivityIndicatorAnimationTypeBallScaleMultiple;
    [self addSubview:self.loadingView];
}


#pragma mark - Configuration

- (void)configureWithChannel:(KGChannel *)channel
           loadingInProgress:(BOOL)loadingInProgress {
    self.channel = channel;
    self.titleString = channel.displayName;
    self.titleLabel.text = channel.displayName;
    [self hideStatusIndicatorView];
    
    if (channel.type == KGChannelTypePrivate) {
        [self toggleLoadingViewVisibility:loadingInProgress];
        if (loadingInProgress) {
            [self.loadingView startAnimating];
        } else {
            KGUserNetworkStatus status = networkStatusFromPrivateChannel(channel);
            [self showStatusIndicatorView];
            [self configureStatusIndicatiorWithUserStatus:status];
        }

    } else {
        [self hideStatusIndicatorView];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)configureStatusIndicatiorWithUserStatus:(KGUserNetworkStatus)status {
    self.statusIndicatorView.layer.borderWidth =
            (status == KGUserOnlineStatus || status == KGUserAwayStatus) ? 0 : 1;
    
    switch (status) {
        case KGUserOnlineStatus: {
            self.statusIndicatorView.backgroundColor = [UIColor kg_greenColor];
            break;
        }
            
        case KGUserAwayStatus: {
            self.statusIndicatorView.backgroundColor = [UIColor kg_yellowColor];
            break;
        }
            
        case KGUserUnknownStatus: {
            [self toggleLoadingViewVisibility:YES];
            [self hideStatusIndicatorView];
            break;
        }
            
        default: {
            self.statusIndicatorView.layer.borderColor = [UIColor kg_lightGrayColor].CGColor;
            self.statusIndicatorView.backgroundColor = [UIColor clearColor];
            break;
        }
    }
}


#pragma mark - Private

- (void)toggleLoadingViewVisibility:(BOOL)shouldBeShown {
    self.loadingView.hidden = !shouldBeShown;
}

- (void)hideStatusIndicatorView {
    self.statusIndicatorView.hidden = YES;
}

- (void)showStatusIndicatorView {
    self.statusIndicatorView.hidden = NO;
}


#pragma mark - Helpers

KGUserNetworkStatus networkStatusFromPrivateChannel(KGChannel *channel) {
    KGUser *user = [KGUser managedObjectById:channel.interlocuterId];
    
    return user.networkStatus;
}

+ (CGFloat)widthOfString:(NSString *)string font:(UIFont *)font {
    if (string) {
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        return  ceilf([[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
    }
    
    return 0.00001;
}

@end
