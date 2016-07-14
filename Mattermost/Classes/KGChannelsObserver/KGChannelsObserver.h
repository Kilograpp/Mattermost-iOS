//
//  KGChannelsObserver.h
//  Mattermost
//
//  Created by Igor Vedeneev on 14.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGChannel;

@protocol KGChannelsObserverDelegate <NSObject>

@required
- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier;

@end


@interface KGChannelsObserver : NSObject

@property (nonatomic, strong) KGChannel *selectedChannel;
@property (nonatomic, weak) id<KGChannelsObserverDelegate> delegate;


+ (instancetype)sharedObserver;

- (void)playAlertSound;

@end
