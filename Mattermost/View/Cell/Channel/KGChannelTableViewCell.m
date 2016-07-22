//
//  KGChannelTableViewCell.m
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import "KGChannelTableViewCell.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGChannel.h"
#import "KGUserStatusObserver.h"
#import "KGUserStatus.h"

const static CGFloat kHeightCellLeftMenu = 50;

@interface KGChannelTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *sharpLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *userStatusUnknownIndicator;
@property (strong, nonatomic) UIColor *labelColor;
@property (strong, nonatomic) UIColor *dotViewColor;
@property (strong, nonatomic) UIColor *dotViewBorderColor;
@property (strong, nonatomic) UIColor *dotViewBorderColorIfSelected;

@property (strong, nonatomic) KGUserStatus *userStatus;

@end

@implementation KGChannelTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return self;
}


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupChannelNameLabel];
    [self setupBachground];
    [self setupDotView];
    [self setupSelectedView];
    [self setupUserStatusActivityIndicator];
}


#pragma mark - Setup

- (void)setupBachground {
    self.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
}

- (void)setupChannelNameLabel {
    self.channelNameLabel.font = [UIFont kg_regular18Font];
    self.channelNameLabel.textColor = [UIColor kg_sectionColorLeftMenu];
    self.sharpLabel.textColor = [UIColor kg_sectionColorLeftMenu];
}

- (void)setupUserStatusActivityIndicator {
    self.userStatusUnknownIndicator.type = DGActivityIndicatorAnimationTypeBallScaleMultiple;
    self.userStatusUnknownIndicator.backgroundColor = self.dotViewColor;
    self.userStatusUnknownIndicator.tintColor = [UIColor kg_whiteColor];
    self.userStatusUnknownIndicator.size = 12;
    self.userStatusUnknownIndicator.hidden = YES;
}

- (void)setupDotView {
    self.dotView.backgroundColor = self.dotViewColor;
    self.dotView.layer.masksToBounds = NO;
    self.dotView.layer.cornerRadius = self.dotView.bounds.size.height / 2;
    self.dotView.layer.borderWidth = 1.2f;
    self.dotView.layer.borderColor = self.dotViewBorderColor.CGColor;
}

- (void)setupSelectedView {
    self.selectedView.backgroundColor = [UIColor kg_whiteColor];
    self.selectedView.layer.cornerRadius = 3;
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGChannel class]]) {
        KGChannel *channel = object;
        
        self.selectedView.hidden = !self.isSelectedCell;
        self.channelNameLabel.text = channel.displayName;
        
        if (channel.type == KGChannelTypePrivate) {
            [self configureCellForChannelPrivate:channel.hasNewMessages];
            self.userStatus = [[KGUserStatusObserver sharedObserver] userStatusForIdentifier:channel.identifier];
            [self configureDotViewForNetworkStatus:channel.networkStatus];
        } else {
            [self configureCellForCnannelPublic:channel.hasNewMessages];
        }
        
        [self configureForState:self.isSelectedCell];
        
        [self setupDotView];
    }
}

- (void)configureForState:(BOOL)isSelected {
    self.selectedView.hidden = !isSelected;
    self.channelNameLabel.textColor = (isSelected) ? [UIColor kg_blackColor] : self.labelColor;
    self.sharpLabel.textColor = (isSelected) ? [UIColor kg_blackColor] : self.labelColor;
    //self.dotView.backgroundColor = self.dotViewColor;
    
    UIColor* statusShouldColor = (isSelected) ? [UIColor kg_blueColor] : [UIColor kg_whiteColor];
    
    if (![statusShouldColor isEqual:self.userStatusUnknownIndicator.tintColor]) {
        
        [self.userStatusUnknownIndicator stopAnimating];
        self.userStatusUnknownIndicator.tintColor = statusShouldColor;
        self.userStatusUnknownIndicator.type = DGActivityIndicatorAnimationTypeTwoDots;
        self.userStatusUnknownIndicator.type = DGActivityIndicatorAnimationTypeBallScaleMultiple;
        [self.userStatusUnknownIndicator startAnimating];
    }
    
    self.dotView.layer.borderColor = (isSelected) ? self.dotViewBorderColorIfSelected.CGColor : self.dotViewBorderColor.CGColor;
}

- (void)configureDotViewForNetworkStatus:(KGUserNetworkStatus)networkStatus {
    switch (networkStatus) {
        case KGUserOnlineStatus: {
            self.dotViewColor = [UIColor kg_greenColor];
            self.dotViewBorderColor = [UIColor kg_greenColor];
            self.dotViewBorderColorIfSelected = [UIColor kg_greenColor];
            break;
        }
            
        case KGUserAwayStatus: {
            self.dotViewColor = [UIColor kg_yellowColor];
            self.dotViewBorderColor = [UIColor kg_yellowColor];
            self.dotViewBorderColorIfSelected = [UIColor kg_yellowColor];
            
            break;
        }
        case KGUserUnknownStatus: {
            self.dotView.hidden = YES;
            self.userStatusUnknownIndicator.hidden = NO;
            [self.userStatusUnknownIndicator startAnimating];
            break;
        }
            
        default: {
            self.dotViewColor = [UIColor clearColor];
            self.dotViewBorderColor = [UIColor kg_sectionColorLeftMenu];
            self.dotViewBorderColorIfSelected = [UIColor kg_blackColor];
            break;
        }
    }
}

- (void)configureCellForChannelPrivate:(BOOL)boolIsNewMessage {
    self.dotView.hidden = NO;
    self.sharpLabel.hidden = YES;
    self.labelColor = (boolIsNewMessage) ? [UIColor kg_whiteColor]:[UIColor kg_sectionColorLeftMenu];
    self.channelNameLabel.font = (boolIsNewMessage) ? [UIFont kg_boldText18Font] : [UIFont kg_regular18Font];
}

- (void)configureCellForCnannelPublic:(BOOL)boolIsNewMessage{
    self.dotView.hidden = YES;
    self.sharpLabel.hidden = NO;
    self.labelColor = (boolIsNewMessage) ? [UIColor kg_whiteColor]:[UIColor kg_sectionColorLeftMenu];
    self.channelNameLabel.font = (boolIsNewMessage) ? [UIFont kg_boldText18Font] : [UIFont kg_regular18Font];
    self.sharpLabel.font = (boolIsNewMessage) ? [UIFont kg_boldText18Font] : [UIFont kg_regular18Font];
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    return kHeightCellLeftMenu;
}


#pragma mark - Override

- (void)prepareForReuse {
    self.dotView.hidden = NO;
    [self.userStatusUnknownIndicator stopAnimating];
    self.userStatusUnknownIndicator.hidden = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = [[UIColor kg_leftMenuBackgroundColor] colorWithAlphaComponent:0.8];
}

@end
