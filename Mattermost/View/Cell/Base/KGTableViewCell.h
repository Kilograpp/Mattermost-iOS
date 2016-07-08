//
//  KGTableViewCell.h
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGPost.h"
@interface KGTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;
+ (CGFloat)heightWithObject:(id)object;

- (void)awakeFromNib __attribute((objc_requires_super));
- (void)configureWithObject:(id)object;

+ (UIImage *)placeholderBackground;

@property (copy, nonatomic) void(^photoTapHandler)(NSUInteger photoNumber, UIView *cell);
@property (copy, nonatomic) void(^fileTapHandler)(NSUInteger fileNumber);
@property (copy, nonatomic) void(^errorTapHandler)(KGPost *post);
@property (nonatomic, copy, nonnull) void (^mentionTapHandler)(NSString *nickname);
@property (nonatomic, strong) UIButton *errorView;
@property (copy, nonatomic) void(^profileTapHandler)(KGUser *user);
- (void)startAnimation;
- (void)finishAnimation;
@end
