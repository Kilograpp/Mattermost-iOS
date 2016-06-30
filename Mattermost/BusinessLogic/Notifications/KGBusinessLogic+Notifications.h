//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@interface KGBusinessLogic (Notifications)
- (void)registerForRemoteNotifications;
- (void)saveNotificationsToken:(NSData *)token;
- (void)subscribeToRemoteNotificationsIfNeededWithCompletion:(void(^)(KGError *error))completion;
@end