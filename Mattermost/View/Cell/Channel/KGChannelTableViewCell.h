//
//  KGChannelTableViewCell.h
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
#import "KGChannel.h"
@interface KGChannelTableViewCell : KGTableViewCell
- (void)configureWitChannelName:(NSString *)channelName;
- (void)configurateWithChannel:(KGChannel *)channel;
@end
