//
//  KGTableViewCell.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"

@implementation KGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)configureWithObject:(id)object {
    
}

+ (CGFloat)heightWithObject:(id)object {
    return 51.f;
}

+ (UIImage *)placeholderBackground {
    CGRect rect = CGRectMake(0, 0, 40, 40);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef ref = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20].CGPath;
    CGContextAddPath(context, ref);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)startAnimation {
    
}

- (void)finishAnimation {
    
}
@end
