//
//  KGBusinessLogic+Team.m
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Team.h"
#import <RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGTeam.h"
#import "KGPreferences.h"
#import "KGUtils.h"
#import "KGObjectManager.h"

@implementation KGBusinessLogic (Team)

#pragma mark - Network

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion {
    NSString* path = [KGTeam initialLoadPathPattern];

    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        [self setSiteNameFromMappingResult:mappingResult];

        BOOL hasSingleTeam = [self isMappingResultContainsOnlyOneTeam:mappingResult];
        if (hasSingleTeam) {
            [self setFirstTeamAsCurrentFromMappingResult:mappingResult];
        }

        safetyCall(completion, !hasSingleTeam, nil);
    } failure:^(KGError *error) {
        safetyCall(completion, YES, error);
    }];
}

#pragma mark - Current Team

- (NSString*)currentTeamId {
    return [[KGPreferences sharedInstance] currentTeamId];
}

- (KGTeam *)currentTeam {
    return [KGTeam managedObjectById:[self currentTeamId]];
}

- (KGTeam *)currentTeamInContext:(NSManagedObjectContext*)context{
    return [KGTeam managedObjectById:[self currentTeamId] inContext:context];
}

#pragma mark - Mapping Result Helpers

- (void)setFirstTeamAsCurrentFromMappingResult:(RKMappingResult*)mappingResult {
    [[KGPreferences sharedInstance] setCurrentTeamId:[[mappingResult.dictionary[@"teams"] firstObject] identifier]];
    [[KGPreferences sharedInstance] save];
}

- (void)setSiteNameFromMappingResult:(RKMappingResult*)mappingResult {
    [[KGPreferences sharedInstance] setSiteName:mappingResult.dictionary[@"client_cfg"][@"siteName"]];
}

- (BOOL)isMappingResultContainsOnlyOneTeam:(RKMappingResult *)mappingResult {
    return [mappingResult.dictionary[@"teams"] count] == 1;
}

//- (NSInteger)numberOfTeam:(RKMappingResult *)mappingResult {
//     [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
//    return [mappingResult.dictionary[@"teams"] count];
//     } failure:^(KGError *error) {
//         safetyCall(nil, YES, error);
//     }];
//}
@end
