//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"
@class KGChannel;
@class KGPost;

@interface KGBusinessLogic (Posts)

- (void)loadNextPageForChannel:(KGChannel*)channel completion:(void (^)(KGError* error))completion;

- (void)loadFirstPageForChannel:(KGChannel*)channel completion:(void (^)(KGError* error))completion;

- (void)loadPostsForChannel:(KGChannel*)channel
                       page:(NSNumber *)page
                       size:(NSNumber *)size // Recommended - 60
                 completion:(void(^)(KGError *error))completion;

- (void)updatePost:(KGPost*)post completion:(void(^)(KGError *error))completion;
- (void)sendPost:(KGPost *)post
      completion:(void(^)(KGError *error))completion;

@end