//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Socket.h"
#import "KGBusinessLogic+Session.h"
#import "KGUtils.h"
#import "KGBusinessLogic+Channel.h"
#import "KGChannelNotification.h"
#import "KGObjectManager.h"
#import "KGChannel.h"
#import "KGBusinessLogic+Team.h"
#import "RKMapperOperation_Private.h"
#import "KGPost.h"
#import "RKResponseMapperOperation.h"
#import "NSManagedObject+MagicalRecord.h"
#import "KGUser.h"
#import "KGBusinessLogic+Posts.h"
#import "NSStringUtils.h"
#import <SRWebSocket.h>


static NSString * const KGChannelIdentifierKey = @"channel_id";
static NSString * const KGTeamIdentifierKey = @"team_id";
static NSString * const KGUserIdentifierKey = @"user_id";
static NSString * const KGActionNameKey = @"action";


@interface KGBusinessLogic () <SRWebSocketDelegate>

@end

@implementation KGBusinessLogic (Socket)

- (BOOL)shouldOpenSocket {
    return [self isSignedIn] && !self.socket;
}


- (void)openSocket {
    if ([self shouldOpenSocket]) {
        [self rocketFuckingSocket];
    }
}

- (void)closeSocket {
    [self.socket close];
    self.socket = nil;

}

- (void)rocketFuckingSocket {
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURL:[self socketURL]];
    [socket setRequestCookies:@[[self authCookie]]];
    [socket setDelegate:self];
    self.socket = socket;
    [self.socket open];

}


#pragma mark - WebSocket Delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSData*)data {
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self postNotificationWithDictionary:message];
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return NO;
}

#pragma mark - Notifications

- (void)sendNotificationWithAction:(KGChannelAction)action forChannel:(KGChannel *)channel {
    [self sendNotificationWithAction:action forChannelIdentifier:channel.identifier];
}
- (void)sendNotificationWithAction:(KGChannelAction)action forChannelIdentifier:(NSString *)identifier{

    if (![self shouldSendNotification]){
        return;
    }

    NSDictionary *parameters = @{
            KGChannelIdentifierKey : identifier,
            KGTeamIdentifierKey : [self currentTeamId],
            KGActionNameKey : [self stringForAction:action]
    };
    [self.socket send:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
}


- (void)postNotificationWithDictionary:(NSDictionary *)dictionary {
    NSString* channelId = dictionary[KGChannelIdentifierKey];
    NSString* userId = dictionary[KGUserIdentifierKey];
    NSString* action = dictionary[KGActionNameKey];
    NSString *postString = dictionary[@"props"][@"post"];

    if (![NSStringUtils isStringEmpty:postString]) {

        NSDictionary *postDict = [NSJSONSerialization JSONObjectWithData:[postString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

        KGPost *post = [KGPost MR_createEntity];
        [post setIdentifier:postDict[@"id"]];
        [post setChannel:[KGChannel managedObjectById:channelId]];
        [self updatePost:post completion:^(KGError *error) {
            NSString *channelNotificationName = [[KGBusinessLogic sharedInstance] notificationNameForChannelWithIdentifier:channelId];
            KGChannelNotification *notification = [KGChannelNotification notificationWithUserIdentifier:userId action:[self actionForString:action]];
            [[NSNotificationCenter defaultCenter] postNotificationName:channelNotificationName object:notification];
        }];
    } else {
        NSString *channelNotificationName = [[KGBusinessLogic sharedInstance] notificationNameForChannelWithIdentifier:channelId];
        KGChannelNotification *notification = [KGChannelNotification notificationWithUserIdentifier:userId action:[self actionForString:action]];
        [[NSNotificationCenter defaultCenter] postNotificationName:channelNotificationName object:notification];
    }




}

#pragma mark - KGChannelAction

- (NSString*)stringForAction:(KGChannelAction)action {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[self.class dictionaryOfActionsForString]];
    for (NSString *key in [dictionary allKeys]) {
        dictionary[dictionary[key]] = key;
        [dictionary removeObjectForKey:key];
    }
    return dictionary[@(action)];

}

- (KGChannelAction)actionForString:(NSString*)string {
    KGChannelAction value;
    [[self.class dictionaryOfActionsForString][string] getValue:&value];
    return value;
}

+ (NSDictionary *)dictionaryOfActionsForString {
    return @{
            @"typing" : @(KGActionTyping),
            @"channel_view" : @(KGActionView),
            @"posted" : @(KGActionPosted)
    };
}

#pragma mark - Support

- (NSURL*)socketURL {
    NSURLComponents* components = [NSURLComponents componentsWithURL:self.defaultObjectManager.HTTPClient.baseURL resolvingAgainstBaseURL:YES];
    components.scheme = @"wss";
    return [components.URL URLByAppendingPathComponent:@"users/websocket"];
}


- (BOOL)shouldSendNotification {
    static NSDate * lastNotificationDate = nil;
    NSDate *currentDate = [NSDate date];
    if ([currentDate timeIntervalSinceDate:lastNotificationDate] < 2 || !lastNotificationDate) {
        lastNotificationDate = currentDate;
        return YES;
    }
    return NO;
}

@end