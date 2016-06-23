//
// Created by Maxim Gubin on 23/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@interface KGBusinessLogic (ApplicationNotifications)

- (void)handleLaunchingWithOptionsNotification:(NSNotification *)notification;
- (void)handleRemoteNotificationOpeningWithPayload:(NSNotification*)notification;

@end