//
//  KGTableViewCell.h
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (CGFloat)heightWithObject:(id)object;

- (void)awakeFromNib __attribute((objc_requires_super));
- (void)configureWithObject:(id)object;

@property (copy, nonatomic) void(^photoTapHandler)(NSUInteger photoNumber, UIView *cell);

@end
