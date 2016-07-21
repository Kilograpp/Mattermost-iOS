//
//  KGTableViewSectionHeader.m
//  Mattermost
//
//  Created by Tatiana on 20/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewSectionHeader.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "NSString+HeightCalculation.h"
#import "KGUIUtils.h"

@interface KGTableViewSectionHeader()
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic, copy) NSString *titleString;
@end
@implementation KGTableViewSectionHeader


//- (instancetype)init {
//    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
////    if (self = [super init]) {
////        [self setup];
////    }
////
//    return self;
//}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self setup];
//}

- (void)setup {
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont kg_bold16Font];
    self.dateLabel.textColor = [UIColor kg_blackColor];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor kg_lightLightGrayColor];
    [self addSubview:self.dateLabel];
    [self addSubview:self.lineView];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[NSString class]]){
        NSString *str = object;
        self.titleString = object;
        self.dateLabel.text = str;
    }
}


- (void)layoutSubviews {
    CGFloat width = [[self class] widthOfString:self.titleString withFont:[UIFont kg_bold16Font]];
    self.dateLabel.frame = CGRectMake(KGScreenWidth() - 10 - ceilf(width), 5, width, 15);
    self.lineView.frame = CGRectMake(0, 10, CGRectGetMinX(self.dateLabel.frame) - 10, 1);
}


+ (CGFloat)height {
    return 25.0;
}


+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string) {
        NSDictionary *attributes = @{NSFontAttributeName : font};
        return  ceilf([[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
    }

    return 0.00001;
}

#pragma mark - Legacy

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}


- (void)prepareForReuse {
    self.dateLabel.text = nil;
    self.lineView = nil;
}

@end
