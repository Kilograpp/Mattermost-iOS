//
//  KGLeftMenuViewController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"

@protocol KGLeftMenuDelegate <NSObject>

@required
- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier;

@end

@interface KGLeftMenuViewController : KGViewController
@property (nonatomic, weak) id<KGLeftMenuDelegate> delegate;
@end
