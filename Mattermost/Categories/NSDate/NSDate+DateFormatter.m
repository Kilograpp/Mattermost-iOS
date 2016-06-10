//
//  NSDate+DateFormatter.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSDate+DateFormatter.h"
#import <DateTools.h>

@implementation NSDate (DateFormatter)

- (NSString*)timeFormatForMessages {
    return [self formattedDateWithFormat:@"HH:mm a"];
}

@end
