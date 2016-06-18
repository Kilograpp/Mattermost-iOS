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
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

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
    self.titleMenuLabel.font = [UIFont kg_semibold16Font];
    self.titleMenuLabel.textColor = [UIColor kg_whiteColor];
}


#pragma mark - Public Setup

- (void)configureWithImageName:(NSString *)imageName title:(NSString *)title {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    self.titleMenuLabel.text = title;
}

- (void)configureWithImageName:(NSURL *) image {
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    
    [self addSubview:avatar];
    [avatar setCenter:self.iconImageView.center];
    self.iconImageView = nil;
    avatar.layer.cornerRadius = CGRectGetHeight(avatar.bounds) / 2;
    avatar.clipsToBounds = YES;
    avatar.backgroundColor = [UIColor whiteColor];
    [avatar setImageWithURL:image placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}
#pragma mark - Override

-(void)configureWithObject:(id)object{
    if ([object isKindOfClass: [KGRightMenuDataSourceEntry class]]) {
        KGRightMenuDataSourceEntry *dataSourse = object;
        [self configureWithImageName:dataSourse.iconName title:dataSourse.title];
    }

}

+ (CGFloat)heightWithObject:(id)object {
    CGFloat heightScreen =  [[UIScreen mainScreen] bounds].size.height;
    return (heightScreen - 20) / 9 ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.contentView.backgroundColor = selected ? [UIColor kg_lightBlueColor] : [UIColor kg_leftMenuBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.alpha = 0.7f;
    } else {
        self.contentView.alpha = 1.f;
    }
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}


@end
