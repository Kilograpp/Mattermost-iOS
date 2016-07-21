//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGTheme;

@interface KGPreferences : NSObject<NSCoding>

@property (copy, nonatomic) NSString * deviceUuid;
@property (copy, nonatomic) NSString * serverBaseUrl;
@property (copy, nonatomic) NSString * currentUserId;
@property (copy, nonatomic) NSString * currentTeamId;
@property (copy, nonatomic) NSString * siteName;
@property (copy, nonatomic) NSString * lastChannelId;
@property (strong, nonatomic) KGTheme* currentTheme;

@property (assign) BOOL shouldCompressImages;

+ (instancetype)sharedInstance;
- (void)save;
- (void)reset;

@end