//
//  KGChannelTableViewCell.m
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChannelTableViewCell.h"

@interface KGChannelTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;

@end
@implementation KGChannelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setupChannelNameLabel {
    //self.channelNameLabel.
}

- (void)configureWitChannelName:(NSString *)channelName {
    self.channelNameLabel.text = channelName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
