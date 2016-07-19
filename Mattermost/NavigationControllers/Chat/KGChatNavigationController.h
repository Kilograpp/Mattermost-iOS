//
//  KGChatNavigationController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGNavigationController.h"
@class KGChannel;

@protocol KGChatNavigationDelegate <NSObject>
//FIXME: метод совершает действие - название должно содержать действие: например, navigateToChannelMembersList и чуть больше информативности.
//FIXME: делагат должен выполнять дейтсвие по нажатию, т.е это не обязательно переход к членам канала. название метода должно это отображать - например didSelectTitleViewWithChannelIdentifier:(NSString *)channelId
- (void)navigationToMembers;
@end

@interface KGChatNavigationController : KGNavigationController

- (void)configureTitleViewWithChannel:(KGChannel *)channel
                 loadingInProgress:(BOOL)loadingInProgress;
//FIXME: у UINavigationController уже есть делегат, стоит переименовать переменную в kg_delegate или аналогичное
@property (nonatomic, weak) id<KGChatNavigationDelegate> delegate;
@end
