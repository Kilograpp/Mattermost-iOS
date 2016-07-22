//
//  KGBusinessLogic+SignIn.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Session.h"
#import <RestKit.h>
#import <RKManagedObjectStore.h>
#import <MagicalRecord/MagicalRecord.h>
#import <SOCKit/SOCKit.h>
#import "KGUser.h"
#import "KGNotificationValues.h"
#import "KGPreferences.h"
#import "KGObjectManager.h"
#import "KGBusinessLogic+Notifications.h"
#import "KGUtils.h"
#import "KGBusinessLogic+Socket.h"
#import "KGUserStatusObserver.h"
#import "NSString+Validation.h"
#import "KGHardwareUtils.h"
#import "KGUserStatus.h"

extern NSString * const KGAuthTokenHeaderName;

@implementation KGBusinessLogic (Session)

#pragma mark - Network


- (void)validateServerAddress:(void(^)(KGError *error))completion {
    [self.defaultObjectManager getObjectsAtPath:@"teams/all_team_listings" success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)updateStatusForUsers:(NSArray<KGUser*>*) users completion:(void(^)(KGError *error))completion {
    [self updateStatusForUsersWithIds:[users valueForKey:[KGUserAttributes identifier]] completion:completion];
}

- (void)sendLogoutRequestWithCompletion:(void(^)(KGError *error))completion {
    NSString* path = [KGUser logoutPathPattern];
    [self.defaultObjectManager postObjectAtPath:path success:^(RKMappingResult* mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)updateStatusForUsersWithIds:(NSArray<NSString*>*)userIds completion:(void(^)(KGError *error))completion {
    NSString* path = [KGUser usersStatusPathPattern];
    [self.defaultObjectManager postObjectAtPath:path parameters:userIds  success:^(RKMappingResult* mappingResult) {
        [[KGUserStatusObserver sharedObserver] updateWithArray:mappingResult.array];
        safetyCall(completion, nil);
    } failure:^(KGError* error) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *userId in userIds) {
            KGUserStatus *status = [[KGUserStatus alloc] init];
            status.identifier = userId;
            //FIXME: REFACTOR
            status.backendStatus = @"asdd";
            [array addObject:status];
        }
        [[KGUserStatusObserver sharedObserver] updateWithArray:array.copy];
        
        safetyCall(completion, error);
    }];
}

- (void)loginWithEmail:(NSString *)login password:(NSString *)password completion:(void(^)(KGError *error))completion {
    NSDictionary *params = @{ @"login_id" : login, @"password" : password, @"token" : @"" };
    NSString *path = [KGUser authPathPattern];
    [self.defaultObjectManager postObjectAtPath:path parameters:params success:^(RKMappingResult *mappingResult) {
        [self setDefaultValueForImagesCompression];
        [self updateCurrentThemeWithObject:mappingResult.dictionary[@"theme_props"]];
        [self updateCurrentUserWithObject:mappingResult.dictionary[[NSNull null]]];
        [self subscribeToRemoteNotificationsIfNeededWithCompletion:completion];
        [self openSocket];
    } failure:completion];
}

- (BOOL)isValidateServerAddress {
    __block BOOL result = NO;
    NSString *address = [[KGPreferences sharedInstance] serverBaseUrl];
    __block NSString *urlAddress = address;
//    NSString *urlRegEx = @"((http|https)://){1}((.)*)";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", urlRegEx];
//    
    [self validateServerAddress:^(KGError *error){
        if (error) {
            [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
                    [[KGPreferences sharedInstance] save];
            urlAddress = [NSString stringWithFormat:@"%@%@", @"https://", address];
            [self validateServerAddress:^(KGError *error){
                if (error) {
                    [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
                    [[KGPreferences sharedInstance] save];
                    urlAddress = [NSString stringWithFormat:@"%@%@", @"http://", address];
                } else {
                    result = YES;
                }
            }];
        } else {
            result = YES;
        }
    }];
    
    if (result) {
        return YES;
    }
    
    [self validateServerAddress:^(KGError *error){
        if (error) {
            [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
            [[KGPreferences sharedInstance] save];
            urlAddress = [NSString stringWithFormat:@"%@%@", @"http://", address];
        } else {
            result = YES;
        }
    }];

    if (result) {
        return YES;
    }
    
    [self validateServerAddress:^(KGError *error){
        if (error) {
            result = NO;
        } else {
            result = YES;
        }
    }];

    return result;
//    if ([urlTest evaluateWithObject:urlAddress]) {
//        if ([urlAddress kg_isValidUrl]) {
//            return YES;
//        }
//    }
//    urlAddress = [NSString stringWithFormat:@"%@%@", @"https://", address];
//    if ([urlAddress kg_isValidUrl]) {
//        [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
//        [[KGPreferences sharedInstance] save];
//        return YES;
//    }
//    urlAddress = [NSString stringWithFormat:@"%@%@", @"http://", address];
//    if ([urlAddress kg_isValidUrl]) {
//        [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
//        [[KGPreferences sharedInstance] save];
//        return YES;
//    }
//    return NO;
    
}

- (void)updateImageForCurrentUser:(UIImage*)image withCompletion:(void(^)(KGError *error))completion{
    NSString* path = [KGUser uploadAvatarPathPattern];
    [self.defaultObjectManager postImage:image withName:@"image" atPath:path parameters:nil success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion
                                progress:^(NSUInteger persentValue) {
                                    NSLog(@"%d", persentValue);
    }];
}

#pragma mark - User

- (NSString *)currentUserId {
    return [[KGPreferences sharedInstance] currentUserId];
}

- (KGUser *)currentUser {
    return [KGUser managedObjectById:[self currentUserId]];
}

- (void)setDefaultValueForImagesCompression {
    [[KGPreferences sharedInstance] setShouldCompressImages:YES];
}

- (void)updateCurrentThemeWithObject:(KGTheme*)theme {
    [[KGPreferences sharedInstance] setCurrentTheme:theme];
}

- (void)updateCurrentUserWithObject:(KGUser*)user {
    [[KGPreferences sharedInstance] setCurrentUserId:user.identifier];
    [[KGPreferences sharedInstance] save];
}

- (NSURL *)imageUrlForUser:(KGUser *)user {
    NSString* pathPattern = SOCStringFromStringWithObject([KGUser avatarPathPattern], user);
    return [self.defaultObjectManager.HTTPClient.baseURL URLByAppendingPathComponent:pathPattern];
}

#pragma mark - Sign In & Out

- (BOOL)isSignedIn {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:KGAuthTokenHeaderName]){
            return YES;
        }
    }
    return NO;
}

- (void)signOutWithCompletion:(void(^)(KGError *error))completion {
    [self sendLogoutRequestWithCompletion:^(KGError* error) {
        [self resetPersistentStore];
        [self clearCookies];
        [self closeSocket];
        [[KGPreferences sharedInstance] reset];
        safetyCall(completion, nil);
    }];

}

#pragma mark - Resetters

- (void)resetPersistentStore {
    [self.managedObjectStore.mainQueueManagedObjectContext reset];
    NSPersistentStore *store = self.managedObjectStore.persistentStoreCoordinator.persistentStores.firstObject;
    NSString *storePath = store.URL.path;
    NSError *error;
    if (! [self.managedObjectStore.persistentStoreCoordinator removePersistentStore:store error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
    if (! [[NSFileManager defaultManager] removeItemAtPath:storePath error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
    if (! [self.managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (NSHTTPCookie*)authCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:KGAuthTokenHeaderName]) {
            return cookie;
        }
    }
    return nil;
}

- (void)clearCookies {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:KGAuthTokenHeaderName]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}


- (void)updateStatusForAllUsers {
    if (self.isSignedIn){
        if ([[KGHardwareUtils sharedInstance] devicePerformance] == KGPerformanceHigh ||
            [[KGHardwareUtils sharedInstance] currentCpuLoad] < 30) {
            [self updateStatusForUsers:[KGUser MR_findAll] completion:^(KGError* error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationUsersStatusUpdate object:nil];
            }];
        }
        
        
    }
}

@end
