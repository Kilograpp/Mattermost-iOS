//
//  KGChannelTableViewCell.m
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChannelTableViewCell.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGChannel.h"

@interface KGChannelTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UILabel *sharpLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (strong, nonatomic) UIColor *labelColor;
@property (strong, nonatomic) UIColor *dotViewColor;
@property (strong, nonatomic) UIColor *dotViewBorderColor;
@property (strong, nonatomic) UIColor *dotViewBorderColorIfSelected;

@end
@implementation KGChannelTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupChannelNameLabel];
    [self setupBachground];
    [self setupDotView];
    [self setupSelectedView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectedView.backgroundColor = [UIColor kg_whiteColor];
        self.channelNameLabel.textColor = [UIColor kg_blackColor];
        self.sharpLabel.textColor = [UIColor kg_blackColor];
        self.dotView.layer.borderColor = self.dotViewBorderColorIfSelected.CGColor;
        
    } else {
        self.selectedView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
        self.channelNameLabel.textColor = self.labelColor;
        self.sharpLabel.textColor = self.labelColor;
        self.dotView.layer.borderColor = self.dotViewBorderColor.CGColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.selectedView.backgroundColor = [UIColor kg_whiteColor];
        self.channelNameLabel.textColor = [UIColor kg_blackColor];
        self.sharpLabel.textColor = [UIColor kg_blackColor];
        self.dotView.layer.borderColor = self.dotViewBorderColorIfSelected.CGColor;
    } else {
        self.selectedView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
        self.channelNameLabel.textColor = self.labelColor;
        self.sharpLabel.textColor = self.labelColor;
        self.dotView.layer.borderColor = self.dotViewBorderColor.CGColor;
    }
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

- (void)setupDotView {
    self.dotView.backgroundColor = self.dotViewColor;
    self.dotView.layer.cornerRadius = self.dotView.bounds.size.height / 2;
    self.dotView.layer.borderWidth = 1;
    self.dotView.layer.borderColor = self.dotViewBorderColor.CGColor;
}

- (void)setupSelectedView {
    self.selectedView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.selectedView.layer.cornerRadius = 3;
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGChannel class]]) {
        KGChannel *channel = object;

        self.channelNameLabel.text = channel.displayName;
        if (channel.type == KGChannelTypePrivate){
            [self configureCellForChannelPrivate];
            
        } else {
            [self configureCellForCnannelPublic];
        }
    }
}

- (void)configureCellForChannelPrivate {
    self.dotView.hidden = NO;
    self.sharpLabel.hidden = YES;
    //if user online/offline/...
    //if newMessage
    self.labelColor = [UIColor kg_sectionColorLeftMenu];
    self.dotViewColor = [UIColor clearColor];
    self.dotViewBorderColor = [UIColor kg_sectionColorLeftMenu];
    self.dotViewBorderColorIfSelected = [UIColor kg_blackColor];
}

- (void)configureCellForCnannelPublic{
    self.dotView.hidden = YES;
    self.sharpLabel.hidden = NO;
    self.labelColor = [UIColor kg_sectionColorLeftMenu];
}

@end
