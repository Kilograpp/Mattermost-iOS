//
//  KGRightMenuDataSourceEntry.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGRightMenuDataSourceEntry.h"

@implementation KGRightMenuDataSourceEntry

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName titleColor:(UIColor *)titleColor  handler:(void(^)())handler {
    self = [self init];
    if (self) {
        _title = title;
        _iconName = iconName;
        _handler = [handler copy];
        _titleColor = titleColor;
    }
    
    return self;
}

+ (instancetype)entryWithTitle:(NSString *)title  iconName:(NSString *)iconName titleColor:(UIColor *)titleColor handler:(void(^)())handler {
    KGRightMenuDataSourceEntry *entry = [[self alloc] initWithTitle:title iconName:iconName titleColor:titleColor handler:handler];
    return entry;
}

@end
