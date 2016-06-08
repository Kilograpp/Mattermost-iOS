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

extern NSString * const KGAuthTokenHeaderName;

@implementation KGBusinessLogic (Session)

- (void)loginWithEmail:(NSString *)login password:(NSString *)password completion:(void(^)(KGError *error))completion {
    NSDictionary *params = @{ @"login_id" : login, @"password" : password, @"token" : @"" };
    NSString *path = [KGUser authPathPattern];

    [self.defaultObjectManager postObject:nil path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        [[KGPreferences sharedInstance] setCurrentUserId:[mappingResult.firstObject identifier]];

        if(completion) {
            completion(nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion([KGError errorWithNSError:error]);
        }
    }];
}


- (NSString *)currentUserId {
    return [[KGPreferences sharedInstance] currentUserId];
}

- (KGUser *)currentUser {
    return [KGUser MR_findFirstByAttribute:@"identifier" withValue:[self currentUserId]];
}

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
