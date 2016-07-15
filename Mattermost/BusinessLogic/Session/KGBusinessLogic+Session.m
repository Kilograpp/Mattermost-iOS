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
        NSBatchUpdateRequest *batchUpdate = [[NSBatchUpdateRequest alloc] initWithEntityName:@"User"];
        batchUpdate.propertiesToUpdate = @{ @"backendStatus": @(0) };
        batchUpdate.resultType = NSUpdatedObjectIDsResultType;
        batchUpdate.affectedStores = @[[NSPersistentStore MR_defaultPersistentStore]];
        NSError *err;
        NSBatchUpdateResult     *batchResult    = nil;
        batchResult = (NSBatchUpdateResult *)[[NSManagedObjectContext MR_defaultContext] executeRequest:batchUpdate error:&err];
        
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

//- (void)checkUrlWithCompletion:(void(^)(KGError *error))completion  {
//    NSString *path = [KGUser authPathPattern];
//    [self.defaultObjectManager postObjectAtPath:path parameters:nil success:^(RKMappingResult *mappingResult) {
//        NSLog(@"seccess");
//    }
//                                        failure:completion];
//}

- (BOOL)isValidateServerAddress {
    NSString *address = [[KGPreferences sharedInstance] serverBaseUrl];
    NSString *urlAddress = address;
    NSString *urlRegEx = @"((http|https)://){1}((.)*)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", urlRegEx];
    
    if ([urlTest evaluateWithObject:urlAddress]) {
        if ([urlAddress kg_isValidUrl]) {
            return YES;
        }
    }
    urlAddress = [NSString stringWithFormat:@"%@%@", @"https://", address];
    if ([urlAddress kg_isValidUrl]) {
        [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
        [[KGPreferences sharedInstance] save];
        return YES;
    }
    urlAddress = [NSString stringWithFormat:@"%@%@", @"http://", address];
    if ([urlAddress kg_isValidUrl]) {
        [[KGPreferences sharedInstance] setServerBaseUrl:urlAddress];
        [[KGPreferences sharedInstance] save];
        return YES;
    }
    return NO;
    
}

- (void)updateImageForCurrentUser:(UIImage*)image withCompletion:(void(^)(KGError *error))completion{
    NSString* path = [KGUser uploadAvatarPathPattern];
    [self.defaultObjectManager postImage:image withName:@"image" atPath:path parameters:nil success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
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
        [self updateStatusForUsers:[KGUser MR_findAll] completion:^(KGError* error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationUsersStatusUpdate object:nil];
        }];
        
    }
}

@end
