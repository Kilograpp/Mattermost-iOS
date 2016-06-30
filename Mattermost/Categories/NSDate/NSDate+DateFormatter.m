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

- (NSString *)timeFormatForMessages {
    return [self formattedDateWithFormat:@"HH:mm a"];
}

- (NSString *)dateFormatForMassage {
    return [self formattedDateWithFormat:@"dd.MM.yyyy"];
}

- (NSString *)dateFormatForMessageTitle {
    return [self formattedDateWithFormat:@"MMM dd,yyyy" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
}

@end
