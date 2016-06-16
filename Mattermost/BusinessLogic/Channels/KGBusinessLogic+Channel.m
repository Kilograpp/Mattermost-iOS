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

- (void)updateLastViewDateForChannel:(KGChannel*)channel withCompletion:(void(^)(KGError *error))completion {
    NSString* channelIdentifier = channel.identifier;
    NSString* path = SOCStringFromStringWithObject([KGChannel updateLastViewDatePathPattern], channel);
    [self.defaultObjectManager postObjectAtPath:path success:^(RKMappingResult* mappingResult) {
        KGChannel *innerChannel = [KGChannel managedObjectById:channelIdentifier];
        [innerChannel setLastViewDate:[NSDate date]];
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion {
    NSString * path = SOCStringFromStringWithObject([KGChannel listPathPattern], [self currentTeam]);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)loadExtraInfoForChannel:(KGChannel*)channel withCompletion:(void(^)(KGError *error))completion {
    NSString * path = SOCStringFromStringWithObject([KGChannel extraInfoPathPattern], channel);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (NSString*)notificationNameForChannel:(KGChannel *)channel {
    return [self notificationNameForChannelWithIdentifier:channel.identifier];
}

- (NSString *)notificationNameForChannelWithIdentifier:(NSString *)identifier {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), [identifier uppercaseString]];

}

@end