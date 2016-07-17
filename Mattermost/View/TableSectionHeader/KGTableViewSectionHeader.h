//
//  KGTableViewSectionHeader.h
//  Mattermost
//
//  Created by Tatiana on 20/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGTableViewSectionHeader : UITableViewHeaderFooterView
@property (strong, nonatomic) UILabel *dateLabel;
+ (NSString *)reuseIdentifier;
+ (CGFloat)height;
+ (UINib *)nib;
- (void)configureWithObject:(id)object;
@end
