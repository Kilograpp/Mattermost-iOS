//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic+Socket.h"


@interface KGChannelNotification : NSObject

@property (copy, nonatomic, readonly) NSString* userIdentifier;
@property (assign, readonly) KGChannelAction action;

+ (instancetype)notificationWithUserIdentifier:(NSString *)identifier action:(KGChannelAction)action;

@end