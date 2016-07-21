//
//  KGSoundManager.h
//  Mattermost
//
//  Created by Igor Vedeneev on 15.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGSoundManager : NSObject

- (void)playNewMessageSound;
- (void)playNewMessageSoundForSelectedChannel;

@end
