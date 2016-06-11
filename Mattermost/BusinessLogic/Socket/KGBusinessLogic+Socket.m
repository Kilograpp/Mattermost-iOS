//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Socket.h"
#import "KGBusinessLogic+Session.h"
#import <SRWebSocket.h>

@interface KGBusinessLogic () <SRWebSocketDelegate>



@end

@implementation KGBusinessLogic (Socket)

- (void)rocketFuckingSocket {
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://mattermost.kilograpp.com/api/v3/users/websocket"]];
    [socket setRequestCookies:@[[self authCookie]]];
    [socket setDelegate:self];
    [socket open];
    self.socket = socket;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Did ReceiveMessage: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"DidOpen");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"DidFail: %@", error.localizedDescription);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"DidClose: %@ ", reason);
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"DidReceivePong: ");
}


@end