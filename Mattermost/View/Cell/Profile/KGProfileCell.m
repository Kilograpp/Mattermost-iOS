//
//  KGProfileCell.m
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGProfileCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGProfileDataSource.h"

@interface KGProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@end

@implementation KGProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    self.titleLabel.font = [UIFont kg_regular16Font];
    self.infoLabel.font = [UIFont kg_regular16Font];
    self.titleLabel.textColor = [UIColor kg_blackColor];
    self.infoLabel.textColor = [UIColor kg_lightGrayColor];
}

- (void)configureWithObject:(id)object {
//    self.titleLabel.text = @"Name";
//    self.iconImageView.image = [UIImage imageNamed:@"icn_upload"];
    self.arrowButton.imageView.image = [UIImage imageNamed:@"login_arrow_icon_passive"];
    if ([object isKindOfClass:[KGProfileDataSource class]]){
        KGProfileDataSource *dataSource = object;
        self.titleLabel.text = dataSource.title;
        self.iconImageView.image = [UIImage imageNamed:dataSource.iconName];
        self.infoLabel.text = dataSource.info;
        
    }
}
@end
