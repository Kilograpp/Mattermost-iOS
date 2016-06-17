//
//  KGProfileDataSource.h
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGProfileDataSource : NSObject

+ (instancetype)entryWithTitle:(NSString *)title  iconName:(NSString *)iconName info:(NSString *)info handler:(void(^)())handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) void(^handler)();

@end
