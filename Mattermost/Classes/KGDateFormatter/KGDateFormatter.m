//
//  KGDateFormatter.m
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGDateFormatter.h"

@implementation KGDateFormatter

+ (NSDateFormatter *)sharedChatHeaderDateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    });
    return formatter;
}

@end
