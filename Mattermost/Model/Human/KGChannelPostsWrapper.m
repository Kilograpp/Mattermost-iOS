//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGChannelPostsWrapper.h"
#import "KGTeam.h"
#import "KGChannel.h"


@implementation KGChannelPostsWrapper

+ (instancetype)wrapperForChannel:(KGChannel *)channel page:(NSNumber *)page size:(NSNumber*)size {
    KGChannelPostsWrapper * wrapper = [[self alloc] init];
    [wrapper setIdentifier:channel.identifier];
    [wrapper setTeam:channel.team];
    [wrapper setPage:page];
    [wrapper setSize:size];
    return wrapper;
}

@end