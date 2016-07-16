//
//  KGHardwareUtils.h
//  Mattermost
//
//  Created by Maxim Gubin on 16/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, KGPerformanceLevel) {
    KGPerformanceHigh,
    KGPerformanceLow
};


@interface KGHardwareUtils : NSObject

@property (assign, readonly) KGPerformanceLevel devicePerformance;
@property (assign, readonly) float currentCpuLoad;

+ (instancetype)sharedInstance;

@end
