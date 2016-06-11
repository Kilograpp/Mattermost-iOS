//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGChannelNotification.h"


@implementation KGChannelNotification

+ (instancetype)notificationWithUserIdentifier:(NSString *)identifier action:(KGChannelAction)action userInfo:(NSDictionary *)userInfo {
    return [[self alloc] initWithUserIdentifier:identifier action:action userInfo:(NSDictionary *)userInfo];
}

- (instancetype)initWithUserIdentifier:(NSString *)identifier action:(KGChannelAction)action userInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        _action = action;
        _userIdentifier = identifier;
        _userInfo = userInfo;
    }
    return self;
}

@end