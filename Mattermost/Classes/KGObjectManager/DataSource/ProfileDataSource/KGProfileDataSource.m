//
//  KGProfileDataSource.m
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGProfileDataSource.h"

@implementation KGProfileDataSource

- (instancetype)initWithTitle:(NSString *)title  iconName:(NSString *)iconName info:(NSString *)info handler:(void(^)())handler{
    self = [self init];
    if (self) {
        _title = title;
        _iconName = iconName;
        _handler = [handler copy];
        _info = info;
    }
    
    return self;
}

+ (instancetype)entryWithTitle:(NSString *)title  iconName:(NSString *)iconName info:(NSString *)info handler:(void(^)())handler{
    KGProfileDataSource *entry = [[self alloc] initWithTitle:title  iconName:iconName info:info handler:handler];
    return entry;
}
@end
