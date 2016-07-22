//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGChannelPostsWrapper.h"
#import "KGTeam.h"
#import "KGChannel.h"

extern const NSInteger kDefaultPageSize;

@implementation KGChannelPostsWrapper

+ (instancetype)wrapperForChannel:(KGChannel *)channel {
    return [self wrapperForChannel:channel page:@0 size:@(kDefaultPageSize) lastPostId:nil];
}

+ (instancetype)wrapperForChannel:(KGChannel *)channel lastPostId:(NSString*)lastPostId {
    return [self wrapperForChannel:channel page:@0 size:@(kDefaultPageSize) lastPostId:lastPostId];
}
+ (instancetype)wrapperForChannel:(KGChannel *)channel page:(NSNumber *)page size:(NSNumber*)size {
    return [self wrapperForChannel:channel page:page size:size lastPostId:nil];
}

+ (instancetype)wrapperForChannel:(KGChannel *)channel page:(NSNumber *)page size:(NSNumber*)size lastPostId:(NSString*)lastPostId {
    KGChannelPostsWrapper * wrapper = [[self alloc] init];
    [wrapper setIdentifier:channel.identifier];
    [wrapper setTeam:channel.team];
    [wrapper setPage:page];
    [wrapper setSize:size];
    [wrapper setLastPostId:lastPostId];
    return wrapper;
}

@end