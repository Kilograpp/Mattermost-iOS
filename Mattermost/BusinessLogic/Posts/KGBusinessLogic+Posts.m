//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Posts.h"
#import <SOCKit.h>
#import <RestKit.h>
#import "KGChannel.h"
#import "KGPost.h"
#import "KGChannelPostsWrapper.h"

@implementation KGBusinessLogic (Posts)

- (void)loadPostsForChannel:(KGChannel*)channel
                       page:(NSNumber *)page
                       size:(NSNumber *)size
                 completion:(void(^)(KGError *error))completion {

    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperWithChannel:channel page:page size:size];
    NSString * path = SOCStringFromStringWithObject([KGPost postsPathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completion) {
            completion(nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion) {
            completion([KGError errorWithNSError:error]);
        }
    }];
}

@end