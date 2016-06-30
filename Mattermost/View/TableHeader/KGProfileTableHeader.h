//
//  KGProfileTableHeader.h
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGProfileTableHeader : UIView
- (void)configureWithObject:(id)object;
+ (NSString *)reuseIdentifier;

+ (UINib *)nib;
+ (CGFloat)height;
@end
