//
// Created by Maxim Gubin on 01/07/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <SOCKit/SOCKit.h>
#import "KGBusinessLogic+Commands.h"
#import "KGCommand.h"
#import "KGTeam.h"
#import "KGBusinessLogic+Team.h"
#import "KGObjectManager.h"
#import "KGUtils.h"


@implementation KGBusinessLogic (Commands)

- (void)updateCommandsList:(void (^)(KGError* error))completion {
    KGTeam *currentTeam = [self currentTeam];
    NSString* path = SOCStringFromStringWithObject([KGCommand listPathPattern], currentTeam);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        NSLog(@"MappingResult: %@", mappingResult.array);
        safetyCall(completion, nil);
    } failure:completion];
}

@end