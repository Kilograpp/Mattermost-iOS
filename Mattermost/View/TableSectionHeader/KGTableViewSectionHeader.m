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

@end
@implementation KGTableViewSectionHeader


- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


- (void)setup {
    self.dateLabel.font = [UIFont kg_bold16Font];
    self.dateLabel.textColor = [UIColor kg_blackColor];
//    self.backgroundColor = [UIColor whiteColor];    
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[NSString class]]){
        NSString *str = object;
        self.dateLabel.text = str;
    }
}

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (CGFloat)height {
    return 44.0;
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end
