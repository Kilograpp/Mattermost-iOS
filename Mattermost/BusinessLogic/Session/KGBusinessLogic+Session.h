//
//  KGBusinessLogic+SignIn.h
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"
@class KGError;
@class KGUser;
@interface KGBusinessLogic (Session)

- (void)loginWithEmail:(NSString *)login
              password:(NSString *)password
            completion:(void(^)(KGError *error))completion;


- (NSString*)currentUserId;
- (KGUser*)currentUser;

- (BOOL)isSignedIn;
- (void)signOut;

@end
