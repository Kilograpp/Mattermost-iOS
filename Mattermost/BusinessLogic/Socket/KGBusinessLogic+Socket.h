//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@class SRWebSocket;
@class KGChannel;

typedef NS_ENUM(NSInteger, KGChannelAction) {
    KGActionTyping,
    KGActionView,
    KGActionPosted,
    KGActionUnknown
};
@interface KGBusinessLogic (Socket)

- (void)sendNotificationWithAction:(KGChannelAction)action forChannel:(KGChannel *)channel;
- (void)sendNotificationWithAction:(KGChannelAction)action forChannelIdentifier:(NSString *)identifier;

- (void)openSocket;
- (void)closeSocket;

@end