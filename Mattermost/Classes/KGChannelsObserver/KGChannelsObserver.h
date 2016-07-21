//
//  KGChannelsObserver.h
//  Mattermost
//
//  Created by Igor Vedeneev on 14.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGChannel, KGSoundManager, KGMessagePresenter;

@protocol KGChannelsObserverDelegate <NSObject>

@required
- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier;

@end


@interface KGChannelsObserver : NSObject

@property (nonatomic, strong) KGChannel *selectedChannel;
@property (nonatomic, weak) id<KGChannelsObserverDelegate> delegate;
@property (nonatomic, strong) KGSoundManager *soundManager;
@property (nonatomic, strong) KGMessagePresenter *messagePresenter;

+ (instancetype)sharedObserver;

- (void)playAlertSoundForChannelWithIdentifier:(NSString *)channelId;
- (void)presentMessageNotificationForChannel:(NSString *)channelId;

- (void)postNewMessageNotification;

@end
