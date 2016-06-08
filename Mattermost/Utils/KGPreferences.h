//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KGPreferences : NSObject

@property (strong, nonatomic) NSString * serverBaseUrl;

+ (instancetype)sharedInstance;
- (void)save;

@end