//
//  KGDateFormatter.h
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGDateFormatter : NSObject
+ (NSDateFormatter *)sharedChatHeaderDateFormatter;
@end
