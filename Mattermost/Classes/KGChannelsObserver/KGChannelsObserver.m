//
//  KGChannelsObserver.m
//  Mattermost
//
//  Created by Igor Vedeneev on 14.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChannelsObserver.h"
#import "KGPreferences.h"
#import "KGChannel.h"
#import "KGSoundManager.h"
#import "KGMessagePresenter.h"
#import "KGPost.h"
#import "KGChannel.h"
#import <MagicalRecord/MagicalRecord.h>
#import "KGConstants.h"

@implementation KGChannelsObserver


#pragma mark - Singleton

+ (instancetype)sharedObserver {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}


#pragma mark - Init

- (instancetype)initPrivate {
    return [super init];
}

- (instancetype)init {
    self = nil;
    NSAssert(false, @"use +sharedObserver instead!");
    return self;
}


#pragma mark - Public

- (void)playAlertSoundForChannelWithIdentifier:(NSString *)channelId {
    if ([channelId isEqualToString:self.selectedChannel.identifier]) {
        [self playAlertSoundForSelectedChannel];
    } else {
        [self playAlertSoundForOtherChannel];
    }
}

- (void)presentMessageNotificationForChannel:(NSString *)channelId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel.identifier == %@", channelId];
    KGPost *post = [KGPost MR_findFirstWithPredicate:predicate sortedBy:[KGPostAttributes createdAt] ascending:NO];
    if (![self.selectedChannel.identifier isEqualToString:post.channel.identifier]) {
        [self.messagePresenter presentNotificationWithMessage:post];
    }
}

- (void)postNewMessageNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KGNotificationDidReceiveNewMessage object:nil];
}


#pragma mark - Public setters

- (void)setSelectedChannel:(KGChannel *)selectedChannel {
    _selectedChannel = selectedChannel;
    
    [self handleNewSelectedChannel];
    [self saveChannelToPreferencesAsLast:selectedChannel];
}

- (void)setDelegate:(id<KGChannelsObserverDelegate>)delegate {
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(didSelectChannelWithIdentifier:)]) {
        [self.delegate didSelectChannelWithIdentifier:self.selectedChannel.identifier];
    }
}


#pragma mark - Private

- (void)saveChannelToPreferencesAsLast:(KGChannel *)channel {
    [[KGPreferences sharedInstance] setLastChannelId:channel.identifier];
    [[KGPreferences sharedInstance] save];
}

- (void)handleNewSelectedChannel {
    [self.delegate didSelectChannelWithIdentifier:self.selectedChannel.identifier];
}


- (void)playAlertSoundForSelectedChannel {
    [self.soundManager playNewMessageSoundForSelectedChannel];
}

- (void)playAlertSoundForOtherChannel {
     [self.soundManager playNewMessageSound];
}


#pragma mark - Public getters

- (KGSoundManager *)soundManager {
    if (!_soundManager) {
        _soundManager = [[KGSoundManager alloc] init];
    }
    
    return _soundManager;
}

- (KGMessagePresenter *)messagePresenter {
    if (!_messagePresenter) {
        _messagePresenter = [[KGMessagePresenter alloc] init];
    }
    
    return _messagePresenter;
}

@end
