//
//  KGImageView.m
//  Nabiraem
//
//  Created by Dmitry Arbuzov on 26/03/15.
//  Copyright (c) 2015 Kilogramm. All rights reserved.
//

#import "KGImageView.h"

@interface KGImageView ()
@property (strong, nonatomic) UIView *dimView;
@end

@implementation KGImageView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self addSubview:self.dimView];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.dimView removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.dimView removeFromSuperview];
}

- (UIView *)dimView {
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.3;
    }
    return _dimView;
}

@end
