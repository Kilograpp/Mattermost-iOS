//
//  KGBusinessLogic+Team.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Team.h"
#import <RestKit.h>
#import "KGTeam.h"

@implementation KGBusinessLogic (Team)

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion {
    [self.defaultObjectManager getObjectsAtPath:[KGTeam initialLoadPathPattern] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completion) {
            completion(mappingResult.array.count == 1, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion(YES, [error kg_error]);
        }
    }];
}

@end
