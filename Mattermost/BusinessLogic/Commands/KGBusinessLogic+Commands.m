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
#import "KGChannel.h"


@implementation KGBusinessLogic (Commands)

- (void)updateCommandsList:(void (^)(KGError* error))completion {
    KGTeam *currentTeam = [self currentTeam];
    NSString* path = SOCStringFromStringWithObject([KGCommand listPathPattern], currentTeam);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)executeCommandWithMessage:(NSString*)message
                        inChannel:(KGChannel*)channel
                   withCompletion:(void (^)(KGAction* action, KGError* error))completion {

    KGTeam *currentTeam = [self currentTeam];
    NSString* path = SOCStringFromStringWithObject([KGCommand executePathPattern], currentTeam);

    NSDictionary *parameters = @{
            @"channelId" : channel.identifier,
            @"command" : message
    };

    [self.defaultObjectManager postObjectAtPath:path parameters:parameters success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, mappingResult.firstObject, nil);
    } failure:^(KGError* error) {
        safetyCall(completion, nil, error);
    }];
}

@end