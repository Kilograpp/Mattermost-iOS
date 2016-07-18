//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic+Posts.h"
#import <SOCKit.h>
#import <RestKit/RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannel.h"
#import "KGPost.h"
#import "KGChannelPostsWrapper.h"
#import "KGObjectManager.h"
#import "KGUtils.h"

const NSInteger kDefaultPageSize = 60;

@implementation KGBusinessLogic (Posts)

#pragma mark - Network

- (void)loadNextPageForChannel:(KGChannel*)channel fromPost:(KGPost*)lastPost completion:(void(^)(BOOL isLastPage, KGError *error))completion {
    NSString* lastPostId = lastPost.identifier;
                             
    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperForChannel:channel lastPostId:lastPostId];
    NSString * path = SOCStringFromStringWithObject([KGPost nextPageListPathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path savesToStore:NO success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, mappingResult.count < [wrapper.size intValue], nil);
    } failure:^(KGError* error) {
        
        // Empty posts array is returned as null instead of an empty array. That fixes it.
        if ([error.code intValue] == 1001) {
            safetyCall(completion, YES, nil);
        } else {
            safetyCall(completion, NO, error);
        }
    }];

}

- (void)loadFirstPageForChannel:(KGChannel*)channel completion:(void(^)(BOOL isLastPage, KGError *error))completion{
    KGChannelPostsWrapper* wrapper = [KGChannelPostsWrapper wrapperForChannel:channel];
    NSString * path = SOCStringFromStringWithObject([KGPost firstPagePathPattern], wrapper);
    [self.defaultObjectManager getObjectsAtPath:path useCache:NO savesToStore:NO success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, mappingResult.count < [wrapper.size intValue], nil);
    } failure:^(KGError* error) {
        safetyCall(completion, NO, error);
    }];
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
    [self.defaultObjectManager getObject:post path:path savesToStore:NO success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)sendPost:(KGPost *)post
      completion:(void(^)(KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGPost creationPathPattern], post);
    [self.defaultObjectManager postObject:post path:path parameters:nil savesToStore:NO success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

@end