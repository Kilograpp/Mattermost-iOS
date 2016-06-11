//
//  KGRightMenuCell.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGRightMenuCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGRightMenuDataSourceEntry.h"

@interface KGRightMenuCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleMenuLabel;

@end

@implementation KGRightMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupTitleLabel];
}

- (void)setupTitleLabel {
    self.contentView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.titleMenuLabel.textColor = [UIColor kg_lightBlueColor];
    self.titleMenuLabel.font = [UIFont kg_regular16Font];
}


#pragma mark - Public Setup

- (void)configureWithImageName:(NSString *)imageName title:(NSString *)title {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    self.titleMenuLabel.text = title;
}

#pragma mark - Override

-(void)configureWithObject:(id)object {
    if ([object isKindOfClass: [KGRightMenuDataSourceEntry class]]) {
        KGRightMenuDataSourceEntry *dataSourse = object;
        [self configureWithImageName:dataSourse.iconName title:dataSourse.title];
    }

}

+ (CGFloat)heightWithObject:(id)object {
    CGFloat heightScreen =  [[UIScreen mainScreen] bounds].size.height;
    return (heightScreen - 20) / 7 ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
     //   self.contentView.backgroundColor = [UIColor kg_lightBlueColor];
        self.titleMenuLabel.textColor = [UIColor kg_whiteColor];
       // self.backgroundColor = [UIColor kg_leftMenuHighlightColor];
    } else {
       // self.contentView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
        self.titleMenuLabel.textColor = [UIColor kg_lightBlueColor];
      //  self.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.alpha = 0.7f;
    } else {
        self.contentView.alpha = 1.f;
    }
}




@end
