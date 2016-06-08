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
#import "KGPreferences.h"

@implementation KGBusinessLogic (Team)

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion {
    
    
    NSString* path = [KGTeam initialLoadPathPattern];
    
    [self.defaultObjectManager getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        BOOL hasSingleTeam = [mappingResult.dictionary[@"teams"] count] == 1;

        if (hasSingleTeam) {
            [[KGPreferences sharedInstance] setCurrentTeamId:[[mappingResult.dictionary[@"teams"] firstObject] identifier]];
        }
        
        if (completion) {
            completion(hasSingleTeam, nil);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion(YES, [KGError errorWithNSError:error]);
        }
    }];
}

- (NSString*)currentTeamId {
    return [[KGPreferences sharedInstance] currentTeamId];
}

- (KGTeam *)currentTeam {
    return [KGTeam MR_findFirstByAttribute:@"identifier" withValue:[self currentTeamId]];
}

- (KGTeam *)currentTeamInContext:(NSManagedObjectContext*)context{
    return [KGTeam MR_findFirstByAttribute:@"identifier" withValue:[self currentTeamId] inContext:context];
}

@end
