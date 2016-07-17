//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGTeam;
@class KGChannel;

@interface KGChannelPostsWrapper : NSObject

@property (copy, nonatomic) NSString* lastPostId;
@property (strong, nonatomic) NSNumber* size;
@property (strong, nonatomic) NSNumber* page;
@property (strong, nonatomic) KGTeam* team;
@property (copy, nonatomic) NSString* identifier;

+ (instancetype)wrapperForChannel:(KGChannel*)channel;
+ (instancetype)wrapperForChannel:(KGChannel*)channel lastPostId:(NSString*)lastPostId;
+ (instancetype)wrapperForChannel:(KGChannel *)channel page:(NSNumber *)page size:(NSNumber*)size;

@end