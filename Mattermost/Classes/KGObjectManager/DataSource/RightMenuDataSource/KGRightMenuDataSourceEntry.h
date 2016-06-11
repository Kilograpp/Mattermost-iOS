//
//  KGRightMenuDataSourceEntry.h
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGRightMenuDataSourceEntry : NSObject

+ (instancetype)entryWithTitle:(NSString *)title  iconName:(NSString *)iconName handler:(void(^)())handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) void(^handler)();

@end
