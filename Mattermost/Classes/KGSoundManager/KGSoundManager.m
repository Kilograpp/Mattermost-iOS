//
//  KGSoundManager.m
//  Mattermost
//
//  Created by Igor Vedeneev on 15.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGSoundManager.h"
@import AVFoundation;

#define KG_SELECTED_CHANNEL_MESSAGE_SOUND_ID 1003
#define KG_OTHER_CHANNEL_MESSAGE_SOUND_ID 1007

@implementation KGSoundManager

- (void)playNewMessageSound {
    //        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
    SystemSoundID soundID = KG_OTHER_CHANNEL_MESSAGE_SOUND_ID;
    //        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    //        AudioServicesDisposeSystemSoundID(soundID);
}

- (void)playNewMessageSoundForSelectedChannel {
    //        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
    SystemSoundID soundID = KG_SELECTED_CHANNEL_MESSAGE_SOUND_ID;
    //        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    //        AudioServicesDisposeSystemSoundID(soundID);
}

@end
