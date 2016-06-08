//
//  KGBusinessLogic+Team.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Team.h"
#import <RestKit.h>
#import <MagicalRecord.h>
#import "KGTeam.h"

@implementation KGBusinessLogic (Team)

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion {
    
    
    NSString* path = [KGTeam initialLoadPathPattern];
    
    [self.defaultObjectManager getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        BOOL hasSingleTeam = mappingResult.array.count == 1;
        
        [mappingResult.array.firstObject setValue:@(hasSingleTeam) forKey:@"currentTeam"];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        if (completion) {
            completion(hasSingleTeam, nil);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion(YES, [KGError errorWithNSError:error]);
        }
    }];
}

- (KGTeam *)currentTeam {
    return [KGTeam MR_findFirstByAttribute:@"currentTeam" withValue:@YES];
}

@end
