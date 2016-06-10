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

@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

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
    
    [self setupDeleteButton];
    [self setupChannelNameLabel];
    [self setupBachground];
    [self setupTypeImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectedView.backgroundColor = [UIColor kg_lightBlueColor];
        self.channelNameLabel.textColor = [UIColor kg_whiteColor];
        self.backgroundColor = [UIColor kg_leftMenuHighlightColor];
    } else {
        self.selectedView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
        self.channelNameLabel.textColor = [UIColor kg_lightBlueColor];
        self.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    }
}


#pragma mark - Setup

- (void)setupDeleteButton {
    [self.deleteButton setImage:[UIImage imageNamed:@"map_close_icon"] forState:UIControlStateNormal];
    [self.deleteButton.imageView setTintColor:[UIColor kg_lightBlueColor]];
}

- (void)setupBachground {
    self.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
}

- (void)setupChannelNameLabel {
    self.channelNameLabel.font = [UIFont kg_regular16Font];
    self.channelNameLabel.textColor = [UIColor kg_lightBlueColor];
}

- (void)setupTypeImageView {
    // self.typeImageView.image = [UIImage imageNamed:@"map_close_icon"];
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGChannel class]]) {
        KGChannel *channel = object;
        
        self.channelNameLabel.text = channel.displayName;
        if (channel.type == KGChannelTypePrivate){
            self.deleteButton.hidden = NO;
        } else {
            self.deleteButton.hidden = YES;
        }
    }
}

@end
