//
//  KGPostAction.h
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAction.h"

@interface KGPostAction : KGAction

@property (copy, nonatomic) NSString* channelId;
@property (copy, nonatomic) NSString* message;

@end
