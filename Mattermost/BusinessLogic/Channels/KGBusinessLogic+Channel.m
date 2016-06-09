//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Channel.h"
#import <RestKit.h>
#import <MagicalRecord.h>
#import <SOCKit.h>
#import "KGChannel.h"
#import "KGBusinessLogic+Team.h"
#import "KGObjectManager.h"
#import "KGUtils.h"

@implementation KGBusinessLogic (Channel)

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion {
    NSString * path = SOCStringFromStringWithObject([KGChannel listPathPattern], [self currentTeam]);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

@end