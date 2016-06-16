//
//  NSDate+DateFormatter.h
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateFormatter)

- (NSString *)timeFormatForMessages;
- (NSString *)dateFormatForMassage;
- (NSString *)dateFormatForMessageTitle;

@end
