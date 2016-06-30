//
//  KGTeamCell.m
//  Mattermost
//
//  Created by Tatiana on 16/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTeamCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGTeam.h"
@interface  KGTeamCell ()
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@end

@implementation KGTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


#pragma mark - Setup

- (void)setup {
    self.teamNameLabel.font = [UIFont kg_regular16Font];
    self.teamNameLabel.textColor = [UIColor kg_blackColor];
    self.circleView.layer.cornerRadius = 20.f;
    self.circleLabel.font = [UIFont kg_regular18Font];
    self.circleLabel.textColor = [UIColor whiteColor];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGTeam class]]){
        KGTeam *team = object;
        self.teamNameLabel.text = team.name;
    }
    self.circleView.backgroundColor = [UIColor kg_lightBlueColor];
    self.circleLabel.text = [self.teamNameLabel.text substringToIndex:1];
}

+ (CGFloat)heightWithObject:(id)object {
    return 60.f;
}
@end
