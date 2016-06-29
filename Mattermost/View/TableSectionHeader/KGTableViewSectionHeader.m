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

@interface KGTableViewSectionHeader()
@property (weak, nonatomic) IBOutlet UIView *lineView;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, copy) NSString *titleString;
@end
@implementation KGTableViewSectionHeader


- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
//    if (self = [super init]) {
//        [self setup];
//    }
//
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup {
//    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont kg_bold16Font];
    self.dateLabel.textColor = [UIColor kg_blackColor];
//    self.backgroundColor = [UIColor whiteColor];    
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[NSString class]]){
        NSString *str = object;
        self.titleString = object;
        self.dateLabel.text = str;
    }
}


//- (void)layoutSubviews {
//    CGFloat width = [[self class] widthOfString:self.titleString withFont:[UIFont kg_bold16Font]];
//    self.dateLabel.frame = CGRectMake()
//}


+ (CGFloat)height {
    return 20.0;
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




@end
