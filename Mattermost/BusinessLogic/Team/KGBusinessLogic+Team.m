//
//  KGBusinessLogic+Team.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Team.h"
#import <RestKit.h>
#import <MagicalRecord/MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord/NSManagedObjectContext+MagicalSaves.h>
#import <MagicalRecord/MagicalRecord/NSManagedObject+MagicalFinders.h>
#import "KGTeam.h"

@implementation KGBusinessLogic (Team)

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion {
    [self.defaultObjectManager getObjectsAtPath:[KGTeam initialLoadPathPattern] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completion) {

            if (mappingResult.array.count == 1) {
                [mappingResult.array.firstObject setValue:@YES forKey:@"currentTeam"];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }

            completion(mappingResult.array.count == 1, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion(YES, [error kg_error]);
        }
    }];
}

- (KGTeam *)currentTeam {
    return [KGTeam MR_findFirstByAttribute:@"currentTeam" withValue:@YES];
}

@end
