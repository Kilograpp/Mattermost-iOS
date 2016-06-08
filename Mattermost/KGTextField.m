//
//  KGTextField.m
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTextField.h"
#import "UIColor+KGPreparedColor.h"
#import <Masonry/Masonry.h>

@interface KGTextField () <UITextFieldDelegate>
@property (nonatomic,strong) UIView * underlineView;

@end

@implementation KGTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
    }
    return self;
}


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.underlineView = [[UIView alloc]initWithFrame:CGRectZero];
    self.underlineView.backgroundColor = [UIColor kg_lightGrayColor];
    [self addSubview:self.underlineView];
    self.clipsToBounds = NO;
    [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}


#pragma mark - UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"begin");
    self.underlineView.backgroundColor = [UIColor kg_blueColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"end");
    self.underlineView.backgroundColor = [UIColor kg_lightGrayColor];
}

//- (void) setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    
//    self.subView.backgroundColor = selected ? [UIColor kg_blueColor]: [UIColor kg_lightGrayColor];
//}

@end
