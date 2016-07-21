//
//  KGManualRightMenuCell.m
//  Mattermost
//
//  Created by Mariya on 17.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGManualRightMenuCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGRightMenuDataSourceEntry.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

static const CGFloat KGHeightImage = 20;
static const CGFloat KGHeightCell  = 58;


@interface KGManualRightMenuCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleMenuLabel;

@end

@implementation KGManualRightMenuCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self setupContentView];
        [self setupTitleLabel];
        [self setupIconImageView];
    }
    
    return self;
}
#pragma mark - Setup

- (void)setupContentView {
    self.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.preservesSuperviewLayoutMargins = NO;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setupTitleLabel {
    _titleMenuLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 18, 245, 21)];
    _titleMenuLabel.numberOfLines = 1;
    _titleMenuLabel.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    _titleMenuLabel.font = [UIFont kg_semibold16Font];
    _titleMenuLabel.textColor = [UIColor kg_whiteColor];
    [self addSubview:_titleMenuLabel];
}

- (void)setupIconImageView {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 19, KGHeightImage, KGHeightImage)];
    _iconImageView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconImageView];
    self.center = _iconImageView.center;
}

#pragma mark - Configure

- (void)configureWithImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
    self.titleMenuLabel.text = title;
    self.titleMenuLabel.textColor = titleColor;
}

- (void)configureWithObject:(id)object{
    if ([object isKindOfClass: [KGRightMenuDataSourceEntry class]]) {
        KGRightMenuDataSourceEntry *dataSourse = object;
        [self configureWithImageName:dataSourse.iconName
                               title:dataSourse.title
                          titleColor:dataSourse.titleColor];
    }
    
}

#pragma mark - Public

+ (CGFloat)heightCell{
    return KGHeightCell;
}

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}


#pragma mark - Override

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.backgroundColor = highlighted ? [UIColor kg_leftMenuHeaderColor]  : [UIColor kg_leftMenuBackgroundColor];
    self.titleMenuLabel.backgroundColor = highlighted ? [UIColor kg_leftMenuHeaderColor]  : [UIColor kg_leftMenuBackgroundColor];
    self.iconImageView.backgroundColor = highlighted ? [UIColor kg_leftMenuHeaderColor]  : [UIColor kg_leftMenuBackgroundColor];

}


@end
