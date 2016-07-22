//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Socket.h"
#import "KGBusinessLogic+Session.h"
#import "KGBusinessLogic+Posts.h"
#import "KGBusinessLogic+Channel.h"
#import "KGChannelNotification.h"
#import "KGObjectManager.h"
#import "KGChannel.h"
#import "KGPost.h"
#import "KGUser.h"
#import "KGBusinessLogic+Team.h"
#import "RKMapperOperation_Private.h"
#import "RKResponseMapperOperation.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSStringUtils.h"
#import "KGConstants.h"
#import "KGUtils.h"
#import <SocketRocket/SRWebSocket.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannelsObserver.h"
#import "KGPostUtlis.h"

static const NSInteger KGNotificationSecondsDelay = 5;

static NSString * const KGChannelIdentifierKey = @"channel_id";
static NSString * const KGTeamIdentifierKey = @"team_id";
static NSString * const KGIdentifierKey = @"id";
static NSString * const KGUserIdentifierKey = @"user_id";
static NSString * const KGActionNameKey = @"action";
static NSString * const KGPropertiesKey = @"props";
static NSString * const KGPostKey = @"post";
static NSString * const KGPendingPostIdKey = @"pending_post_id";


@interface KGBusinessLogic () <SRWebSocketDelegate>
@end

@implementation KGBusinessLogic (Socket)

- (BOOL)shouldOpenSocket {
    return [self isSignedIn] && !self.socket;
}


- (void)openSocket {
    if ([self shouldOpenSocket]) {
        [self launchRocketSocket];
    }
}

- (void)closeSocket {
    self.socket.delegate = nil;
    [self.socket close];
    self.socket = nil;
}

- (void)launchRocketSocket {
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURL:[self socketURL]];
    [socket setRequestCookies:@[[self authCookie]]];
    [socket setDelegate:self];
    self.socket = socket;
    [self.socket open];

}


#pragma mark - WebSocket Delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSData*)data {
    [self postNotificationWithDictionary:[self parseMessageFromData:data]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Socket failed with an error: %@", error.localizedDescription);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (!wasClean && self.socket) {
        [self closeSocket];
        [self openSocket];
    }
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return NO;
}

#pragma mark - Server Notifications

- (void)sendNotificationWithAction:(KGChannelAction)action forChannel:(KGChannel *)channel {
    [self sendNotificationWithAction:action forChannelIdentifier:channel.identifier];
}

- (void)sendNotificationWithAction:(KGChannelAction)action forChannelIdentifier:(NSString *)identifier{
    if ([self shouldSendNotification]){
        NSDictionary *parameters = @{
             KGChannelIdentifierKey : identifier,
             KGTeamIdentifierKey    : [self currentTeamId],
             KGActionNameKey        : [self stringForAction:action]
        };
        [self.socket send:[self dataFromDictionary:parameters]];
    }
}

- (BOOL)shouldSendNotification {
    static NSDate * lastNotificationDate = nil;
    NSDate *currentDate = [NSDate date];
    if ([currentDate timeIntervalSinceDate:lastNotificationDate] < KGNotificationSecondsDelay || !lastNotificationDate) {
        lastNotificationDate = currentDate;
        return YES;
    }
    return NO;
}

#pragma mark - Local Notifications


- (void)postNotificationWithDictionary:(NSDictionary *)dictionary {
    NSString* userId     = dictionary[KGUserIdentifierKey];
    NSString* action     = dictionary[KGActionNameKey];
    NSString* channelId  = dictionary[KGChannelIdentifierKey];
    NSString* postString = dictionary[KGPropertiesKey][KGPostKey];

    if (![NSStringUtils isStringEmpty:postString]) { // Make sure a post exists
        NSDictionary *postDict = [self parseMessageFromString:postString];
        if (![self existsPostWithId:postDict[KGIdentifierKey] orPendingId:postDict[KGPendingPostIdKey]]) {
            [self setupPostWithIdentifier:postDict[KGIdentifierKey] forChannelWithIdentifier:channelId success:^(KGPost *post) {
                [self postNotificationWithChannelIdentifier:channelId userIdentifier:userId actionString:action];
            }];
        } // Otherwise its our own message
    } else {
        [self postNotificationWithChannelIdentifier:channelId userIdentifier:userId actionString:action];
    }
}

- (void)postNotificationWithChannelIdentifier:(NSString*)channelId userIdentifier:(NSString*)userId actionString:(NSString*)action {
    NSString *channelNotificationName = [[KGBusinessLogic sharedInstance] notificationNameForChannelWithIdentifier:channelId];
    KGChannelNotification *notification = [KGChannelNotification notificationWithUserIdentifier:userId action:[self actionForString:action]];
    [[NSNotificationCenter defaultCenter] postNotificationName:channelNotificationName object:notification];
    
    if ([self actionForString:action] == KGActionPosted && ![userId isEqualToString:self.currentUserId]) {
        [[KGChannelsObserver sharedObserver] playAlertSoundForChannelWithIdentifier:channelId];
        [[KGChannelsObserver sharedObserver] presentMessageNotificationForChannel:channelId];
        KGChannel *channel = [KGChannel managedObjectById:channelId inContext:[NSManagedObjectContext MR_defaultContext]];
        channel.lastPostDate = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
        [[KGChannelsObserver sharedObserver] postNewMessageNotification];
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

#pragma mark - Post

- (BOOL)existsPostWithId:(NSString*)identifier orPendingId:(NSString*)pendingIdentifier {
    NSManagedObjectContext* context = [NSManagedObjectContext MR_contextWithParent:[[KGPostUtlis sharedInstance] pendingMessagesContext]];
    NSString* identifierCondition = NSStringWithFormat(@"(self.%@ ==[c] '%@')", [KGPostAttributes identifier], identifier);
    NSString* pendingIdentifierCondition = NSStringWithFormat(@"(self.%@ ==[c] '%@')", [KGPostAttributes backendPendingId], pendingIdentifier);
    NSString* finalCondition = NSStringWithFormat(@"%@ || %@", identifierCondition, pendingIdentifierCondition);
    
    BOOL postExists;
    KGPost *post = [KGPost MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:finalCondition] inContext:context];
    postExists = post ? YES : NO;
    
    return postExists;
}

- (void)setupPostWithIdentifier:(NSString*)postIdentifier forChannelWithIdentifier:(NSString*)channelIdentifier success:(void(^)(KGPost *post))completion{
    NSManagedObjectContext* context = [[KGPostUtlis sharedInstance] pendingMessagesContext];
    KGPost *post = [KGPost MR_createEntityInContext:context];
    [post setIdentifier:postIdentifier];
    [post setChannel:[KGChannel managedObjectById:channelIdentifier inContext:context]];
    [self updatePost:post completion:^(KGError *error) {
        [context performBlockAndWait:^{
            [context MR_saveOnlySelfAndWait];
        }];
        
        safetyCall(completion, post);
    }];

}


#pragma mark - Support

- (NSURL*)socketURL {
    NSURLComponents* components = [NSURLComponents componentsWithURL:self.defaultObjectManager.HTTPClient.baseURL resolvingAgainstBaseURL:YES];
    components.scheme = KGSocketProtocol;
    return [components.URL URLByAppendingPathComponent:[KGUser socketPathPattern]];
}

-(NSDictionary*)parseMessageFromString:(NSString*)string {
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];;
}

-(NSDictionary*)parseMessageFromData:(NSData*)data {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (NSData*)dataFromDictionary:(NSDictionary*)dictionary {
    return [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
}



@end