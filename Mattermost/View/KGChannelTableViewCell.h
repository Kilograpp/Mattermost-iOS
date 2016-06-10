//
//  KGChannelTableViewCell.h
//  Mattermost
//
//  Created by Tatiana on 09/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGChannel.h" 
@interface KGChannelTableViewCell : UITableViewCell
- (void)configureWitChannelName:(NSString *)channelName;
- (void)configurateWithChannel:(KGChannel *)channel;
+ (UINib *)nib;
+ (NSString *)reuseIdentifier;
@end
