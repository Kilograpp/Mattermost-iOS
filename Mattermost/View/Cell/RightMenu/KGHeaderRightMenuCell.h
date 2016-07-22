//
//  KGHeaderRightMenuCell.h
//  Mattermost
//
//  Created by Mariya on 17.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGHeaderRightMenuCell : UIView

@property (nonatomic, copy) void(^_Nonnull handler)();
- (void)configureWithObject:(id _Nonnull)object;

- (void)updateAvatarImage;

@end
