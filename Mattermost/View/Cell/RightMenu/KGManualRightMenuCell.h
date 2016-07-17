//
//  KGManualRightMenuCell.h
//  Mattermost
//
//  Created by Mariya on 17.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGManualRightMenuCell : UITableViewCell

+ (NSString * _Nonnull)reuseIdentifier;
+ (CGFloat)heightCell;
- (void)configureWithObject:(id _Nonnull)object;

@end
