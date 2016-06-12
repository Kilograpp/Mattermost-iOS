//
//  KGRightMenuDataSourceEntry.h
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KGRightMenuDataSourceEntry : NSObject

+ (instancetype)entryWithTitle:(NSString *)title  iconName:(NSString *)iconName titleColor:(UIColor *)titleColor handler:(void(^)())handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) void(^handler)();

@end
