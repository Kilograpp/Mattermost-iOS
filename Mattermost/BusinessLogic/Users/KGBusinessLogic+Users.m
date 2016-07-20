//
//  KGBusinessLogic+Users.m
//  Mattermost
//
//  Created by Igor Vedeneev on 20.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Users.h"
#import "KGUser.h"
#import <RestKit.h>
#import <SOCKit.h>
#import "KGBusinessLogic+Team.h"
#import "KGObjectManager.h"
#import "KGUtils.h"

@implementation KGBusinessLogic (Users)

- (void)loadFullUsersListWithCompletion:(void (^)(KGError* error))completion {
    NSString *path = SOCStringFromStringWithObject([KGUser fullUsersListPathPattern], [self currentTeam]);
    
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

@end
