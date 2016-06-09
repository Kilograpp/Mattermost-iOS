//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Notifications.h"
#import "SOCKit-prefix.pch"
#import "KGUtils.h"
#import "KGPreferences.h"
#import "KGUser.h"
#import "KGObjectManager.h"


@implementation KGBusinessLogic (Notifications)

#pragma mark - Network

- (void)registerForRemoteNotifications {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)subscribeToRemoteNotificationsIfNeededWithCompletion:(void(^)(KGError *error))completion {
    if ([self shouldRegisterForRemoteNotifications]) {
        [self subscribeToRemoteNotificationsWithCompletion:completion];
    } else {
        safetyCall(completion, nil);
    }
}

- (void)subscribeToRemoteNotificationsWithCompletion:(void(^)(KGError *error))completion {
    NSString *deviceUuid = [[KGPreferences sharedInstance] deviceUuid];
    NSString *path = [KGUser attachDevicePathPattern];
    NSDictionary *parameters = @{@"device_id" : [@"apple:" stringByAppendingString:deviceUuid]};
    [self.defaultObjectManager postObjectAtPath:path parameters:parameters success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}


#pragma mark - Support

- (BOOL)shouldRegisterForRemoteNotifications {
    return [[KGPreferences sharedInstance] deviceUuid] != nil;
}

- (void)saveNotificationsToken:(NSData *)token {
    NSString *tokenString = [token.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[KGPreferences sharedInstance] setDeviceUuid:tokenString];
}

@end