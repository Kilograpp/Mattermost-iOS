//
//  KGBusinessLogic+SignIn.h
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"
@class UIImage;
@class KGError;
@class KGUser;
@interface KGBusinessLogic (Session)


- (void)validateServerAddress:(void (^)(KGError *error))completion;

- (void)updateStatusForUsers:(NSArray<KGUser*>*)users completion:(void (^)(KGError* error))completion;
- (void)sendLogoutRequestWithCompletion:(void (^)(KGError* error))completion;

- (void)updateStatusForUsersWithIds:(NSArray<NSString*>*)userIds completion:(void (^)(KGError* error))completion;

- (void)loginWithEmail:(NSString *)login
              password:(NSString *)password
            completion:(void(^)(KGError *error))completion;

- (void)updateImageForCurrentUser:(UIImage*)image
                   withCompletion:(void(^)(KGError *error))completion;

- (NSURL *)imageUrlForUser:(KGUser *)user;
- (NSString*)currentUserId;
- (KGUser*)currentUser;

- (BOOL)isSignedIn;
- (void)signOutWithCompletion:(void(^)(KGError *error))completion;

- (NSHTTPCookie*)authCookie;

- (void)updateStatusForAllUsers;
//- (void)checkUrlWithCompletion:(void(^)(KGError *error))completion;
- (BOOL)isValidateServerAddress;
@end
