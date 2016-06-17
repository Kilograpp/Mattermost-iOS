//
//  KGRightMenuCell.h
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGTableViewCell.h"

@interface KGRightMenuCell : KGTableViewCell

- (void)configureWithImageName:(NSString *)imageName title:(NSString *)title;
+ (CGFloat)heightWithObject:(id)object;
- (void)configureWithImageName:(NSURL *) image;
@end
