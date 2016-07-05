//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Posts.h"
#import <SOCKit.h>
#import <RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannel.h"
#import "KGPost.h"
#import "KGChannelPostsWrapper.h"
#import "KGObjectManager.h"
#import "KGUtils.h"

@implementation KGBusinessLogic (Posts)

#pragma mark - Network

- (void)loadNextPageForChannel:(KGChannel*)channel completion:(void(^)(KGError *error))completion {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[KGPostAttributes createdAt] ascending:NO];
    NSString* lastPostId = [[[channel.posts sortedArrayUsingDescriptors:@[sortDescriptor]] lastObject] identifier];
                             
    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperForChannel:channel lastPostId:lastPostId];
    NSString * path = SOCStringFromStringWithObject([KGPost nextPageListPathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];

}

- (void)loadFirstPageForChannel:(KGChannel*)channel completion:(void(^)(KGError *error))completion{
    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperForChannel:channel];
    NSString * path = SOCStringFromStringWithObject([KGPost firstPagePathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)loadPostsForChannel:(KGChannel*)channel
                       page:(NSNumber *)page
                       size:(NSNumber *)size
                 completion:(void(^)(KGError *error))completion {
    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperForChannel:channel page:page size:size];
    NSString * path = SOCStringFromStringWithObject([KGPost firstPagePathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)updatePost:(KGPost*)post completion:(void(^)(KGError *error))completion{
    NSString * path = SOCStringFromStringWithObject([KGPost updatePathPattern], post);
    [self.defaultObjectManager getObject:post path:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)sendPost:(KGPost *)post
      completion:(void(^)(KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGPost creationPathPattern], post);
    [self.defaultObjectManager postObject:post path:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

@end