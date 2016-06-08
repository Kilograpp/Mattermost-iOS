//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"
@class KGChannel;
@interface KGBusinessLogic (Posts)

- (void)loadPostsForChannel:(KGChannel*)channel
                       page:(NSNumber *)page
                       size:(NSNumber *)size // Recommended - 60
                 completion:(void(^)(KGError *error))completion;

@end