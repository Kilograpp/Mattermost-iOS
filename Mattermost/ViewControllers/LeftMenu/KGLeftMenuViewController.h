//
//  KGLeftMenuViewController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"

@class KGChannel;
@protocol KGLeftMenuDelegate <NSObject>

@required
- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier;

@end

@interface KGLeftMenuViewController : KGViewController

- (void)selectChannel:(KGChannel*)channel;

@property (nonatomic, weak) id<KGLeftMenuDelegate> delegate;
@end
