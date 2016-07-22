//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Channel.h"
#import <RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <SOCKit.h>
#import "KGChannel.h"
#import "KGBusinessLogic+Team.h"
#import "KGObjectManager.h"
#import "KGUtils.h"
#import "KGNotificationValues.h"
#import "KGBusinessLogic+Session.h"

@implementation KGBusinessLogic (Channel)

- (void)updateLastViewDateForChannel:(KGChannel*)channel withCompletion:(void(^)(KGError *error))completion {
    NSString* channelIdentifier = channel.identifier;
    NSString* path = SOCStringFromStringWithObject([KGChannel updateLastViewDatePathPattern], channel);
    [self.defaultObjectManager postObjectAtPath:path success:^(RKMappingResult* mappingResult) {
        KGChannel *innerChannel = [KGChannel managedObjectById:channelIdentifier];
        [innerChannel setLastViewDate:[NSDate date]];
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion {
    NSString * path = SOCStringFromStringWithObject([KGChannel listPathPattern], [self currentTeam]);
    [self.defaultObjectManager getObjectsAtPath:path savesToStore:NO success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)loadMoreChannelsWithCompletion:(void(^)(KGError *error))completion {
    NSString *path = SOCStringFromStringWithObject([KGChannel moreListPathPattern], [self currentTeam]);
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

- (void)updateChannelsState {
    if ([self isSignedIn]) {
        // Make sure it happenes after all the hard work
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadChannelsWithCompletion:^(KGError* error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationChannelsStateUpdate object:nil];
            }];
        });
    }
}

@end