//
//  KGMembersViewController.h
//  Mattermost
//
//  Created by Tatiana on 19/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"
#import "KGChannel.h"

@interface KGMembersViewController : KGViewController
@property (nonatomic, strong) KGChannel *channel;
@property (assign, nonatomic) BOOL isAdditionMembers;
@end
