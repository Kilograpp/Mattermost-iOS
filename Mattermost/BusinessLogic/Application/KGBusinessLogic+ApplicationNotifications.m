//
// Created by Maxim Gubin on 23/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+ApplicationNotifications.h"
#import "KGNotificationValues.h"
#import "KGChannel.h"
#import "NSManagedObject+MagicalFinders.h"
#import "KGAppDelegate.h"
#import "ObjectiveSugar.h"
#import "KGLeftMenuViewController.h"
#import "KGSideMenuContainerViewController.h"
#import "KGBusinessLogic+Session.h"
#import "KGChannelsObserver.h"

@implementation KGBusinessLogic (ApplicationNotifications)

- (void)handleLaunchingWithOptionsNotification:(NSNotification *)notification {
    NSDictionary *remoteNotificationInfo = notification.object[UIApplicationLaunchOptionsRemoteNotificationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationDidReceiveRemoteNotification object:remoteNotificationInfo];
}

- (void)handleRemoteNotificationOpeningWithPayload:(NSNotification*)notification {

    NSDictionary *payload = notification.object;

    if (payload && [self isSignedIn]) {
        NSString* message = payload[@"aps"][@"alert"];
        NSString* channelName = [[[message split:@":"] firstObject] substringFromIndex:1];

        KGChannel *channel = [KGChannel MR_findFirstByAttribute:[KGChannelAttributes displayName] withValue:channelName];

        KGAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        KGSideMenuContainerViewController *menuContainerViewController = appDelegate.menuContainerViewController;
        [(KGLeftMenuViewController*)menuContainerViewController.leftMenuViewController selectChannel:channel];
        [[KGChannelsObserver sharedObserver] setSelectedChannel:channel];
    }
}



@end