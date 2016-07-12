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

@property (nonatomic, strong, nullable) KGPost *post;

+ (NSString * _Nonnull)reuseIdentifier;
+ (UINib * _Nonnull)nib;
+ (CGFloat)heightWithObject:(id _Nullable)object;

- (void)awakeFromNib __attribute((objc_requires_super));
- (void)configureWithObject:(id _Nonnull)object;

+ (UIImage * _Nonnull)placeholderBackground;

@property (copy, nonatomic, nullable) void(^photoTapHandler)(NSUInteger photoNumber, UIView * _Nonnull cell);
@property (copy, nonatomic, nullable) void(^fileTapHandler)(NSUInteger fileNumber);
@property (copy, nonatomic, nullable) void(^errorTapHandler)(KGPost * _Nonnull post);
@property (nonatomic, copy, nullable) void (^mentionTapHandler)(NSString * _Nonnull nickname);
@property (nonatomic, strong) UIButton * _Nullable errorView;

@property (copy, nonatomic, nullable) void(^profileTapHandler)(KGUser * _Nonnull user);
- (void)showError;
- (void)hideError;
- (void)startAnimation;
- (void)finishAnimation;
@end
