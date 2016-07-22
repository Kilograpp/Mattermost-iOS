//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@class KGChannel;

@interface KGBusinessLogic (Channel)

- (void)updateLastViewDateForChannel:(KGChannel*)channel withCompletion:(void (^)(KGError* error))completion;

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion;
- (void)loadExtraInfoForChannel:(KGChannel*)channel withCompletion:(void(^)(KGError *error))completion;
- (void)loadMoreChannelsWithCompletion:(void(^)(KGError *error))completion;
- (NSString*)notificationNameForChannelWithIdentifier:(NSString*)identifier;

- (void)updateChannelsState;

- (NSString*)notificationNameForChannel:(KGChannel*)channel;
@end