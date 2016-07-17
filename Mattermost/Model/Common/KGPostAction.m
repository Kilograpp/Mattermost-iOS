//
//  KGPostAction.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGPostAction.h"
#import "KGChannel.h"
#import "KGBusinessLogic+Posts.h"
@implementation KGPostAction

- (void)execute {
    KGChannel* channel = [KGChannel managedObjectById:self.channelId];
    [[KGBusinessLogic sharedInstance] loadPostsForChannel:channel page:@0 size:@1 completion:nil];
}

@end
