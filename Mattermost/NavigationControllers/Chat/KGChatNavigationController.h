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
- (void)didSelectTitleView;
@end

@interface KGChatNavigationController : KGNavigationController

- (void)configureTitleViewWithChannel:(KGChannel *)channel
                 loadingInProgress:(BOOL)loadingInProgress;
@property (nonatomic, weak) id<KGChatNavigationDelegate> kg_delegate;
@end
