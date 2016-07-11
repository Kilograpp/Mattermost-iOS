//
//  NSCalendar+KGSharedCalendar.m
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSCalendar+KGSharedCalendar.h"

@implementation NSCalendar (KGSharedCalendar)
+ (instancetype) kg_sharedGregorianCalendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    return calendar;

}
@end
