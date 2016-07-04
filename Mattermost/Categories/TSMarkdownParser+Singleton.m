//
//  TSMarkdownParser+Singleton.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "TSMarkdownParser+Singleton.h"

@implementation TSMarkdownParser (Singleton)

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self standardParser];
    });
    return sharedInstance;
}

@end
