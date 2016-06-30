//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGChannelNotification.h"


@implementation KGChannelNotification

+ (instancetype)notificationWithUserIdentifier:(NSString *)identifier action:(KGChannelAction)action {
    return [[self alloc] initWithUserIdentifier:identifier action:action];
}

- (instancetype)initWithUserIdentifier:(NSString *)identifier action:(KGChannelAction)action {
    if (self = [super init]) {
        _action = action;
        _userIdentifier = identifier;
    }
    return self;
}

@end