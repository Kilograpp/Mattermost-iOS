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
#import <MagicalRecord.h>
#import "KGUser.h"
#import "KGPreferences.h"
#import "KGObjectManager.h"
#import "KGBusinessLogic+Notifications.h"

extern NSString * const KGAuthTokenHeaderName;

@implementation KGBusinessLogic (Session)

#pragma mark - Network

- (void)loginWithEmail:(NSString *)login password:(NSString *)password completion:(void(^)(KGError *error))completion {
    NSDictionary *params = @{ @"login_id" : login, @"password" : password, @"token" : @"" };
    NSString *path = [KGUser authPathPattern];
    [self.defaultObjectManager postObjectAtPath:path parameters:params success:^(RKMappingResult *mappingResult) {
        [self updateCurrentUserWithObject:mappingResult.firstObject];
        [self subscribeToRemoteNotificationsIfNeededWithCompletion:completion];
    } failure:completion];
}


#pragma mark - Current User

- (NSString *)currentUserId {
    return [[KGPreferences sharedInstance] currentUserId];
}

- (KGUser *)currentUser {
    return [KGUser managedObjectById:[self currentUserId]];
}

- (void)updateCurrentUserWithObject:(KGUser*)user {
    [[KGPreferences sharedInstance] setCurrentUserId:user.identifier];
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

- (void)signOut {
    [self resetPersistentStore];
    [self clearCookies];
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


- (void)clearCookies {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:KGAuthTokenHeaderName]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}

@end
