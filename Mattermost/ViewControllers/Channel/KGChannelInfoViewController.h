//
//  KGChannelInfoViewController.h
//  Mattermost
//
//  Created by Julia Samoshchenko on 20.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"
#import "KGChannel.h"

@interface KGChannelInfoViewController : KGViewController

@property (nonatomic, strong) KGChannel *channel;

@end
