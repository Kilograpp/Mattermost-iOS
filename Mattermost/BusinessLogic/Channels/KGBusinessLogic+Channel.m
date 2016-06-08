//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Channel.h"
#import "RestKit.h"
#import <MagicalRecord.h>
#import "SOCKit.h"
#import "KGChannel.h"
#import "KGBusinessLogic+Team.h"

@implementation KGBusinessLogic (Channel)

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion {
    NSString * path = SOCStringFromStringWithObject([KGChannel listPathPattern], [self currentTeam]);
    [self.defaultObjectManager getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        for (KGChannel * channel in mappingResult.dictionary[@"channels"]) {
            [channel setTeam:[self currentTeam]];
        }

        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        if (completion) {
            completion(nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion([KGError errorWithNSError:error]);
        }
    }];
}

@end