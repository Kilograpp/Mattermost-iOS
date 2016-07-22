//
//  KGLeftMenuViewController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"

@class KGChannel;

@interface KGLeftMenuViewController : KGViewController

- (void)selectChannel:(KGChannel*)channel;

@end
