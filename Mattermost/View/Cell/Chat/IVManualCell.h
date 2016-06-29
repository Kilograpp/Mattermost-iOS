//
//  IVManualCell.h
//  SkillTest
//
//  Created by Igor Vedeneev on 25.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IVManualCell : UITableViewCell
+ (NSString *)reuseIdentifier;
- (void)configureWithObject:(id)object;
+ (CGFloat)heightWithObject:(id)object;

@property (copy, nonatomic) void(^fileTapHandler)(NSUInteger fileNumber);
@property (nonatomic, copy) void (^mentionTapHandler)(NSString *nickname);

@end
