//
//  KGMoveAction.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGAppDelegate.h"
#import "KGBusinessLogic+Channel.h"
#import "KGChannel.h"
#import "KGSideMenuContainerViewController.h"
#import "KGLeftMenuViewController.h"
#import "KGMoveAction.h"
#import "KGChannelsObserver.h"

@implementation KGMoveAction

- (void)execute {
    [[KGBusinessLogic sharedInstance] loadChannelsWithCompletion:^(KGError *error) {
        KGChannel *channel = [KGChannel MR_findFirstByAttribute:[KGChannelAttributes name] withValue:self.location];
//        KGAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        KGSideMenuContainerViewController *menuContainerViewController = appDelegate.menuContainerViewController;
//        [(KGLeftMenuViewController*)menuContainerViewController.leftMenuViewController selectChannel:channel];
        [[KGChannelsObserver sharedObserver] setSelectedChannel:channel];
    }];
}

- (void)setRawLocation:(NSString*)rawLocation {
    self.location = [rawLocation lastPathComponent];
}
+ (RKObjectMapping*)mapping {
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"goto_location" : @"rawLocation"}];
    return mapping;
}
@end
