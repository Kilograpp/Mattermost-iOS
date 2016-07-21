//
//  KGPostUtlis.m
//  Mattermost
//
//  Created by Igor Vedeneev on 19.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGPostUtlis.h"

#import "KGBusinessLogic+Posts.h"
#import "KGBusinessLogic+File.h"
#import "KGBusinessLogic+Session.h"

#import "KGPost.h"
#import "KGChannel.h"
#import "KGError.h"
#import "KGFile.h"

#import <MagicalRecord/MagicalRecord.h>

#import "UIImage+KGRotate.h"
@import UIKit;


@interface KGPostUtlis ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *pendingMessagesContext;
@end

@implementation KGPostUtlis

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Getters

- (NSManagedObjectContext *)pendingMessagesContext {
    if (!_pendingMessagesContext) {
        _pendingMessagesContext = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    }
    
    return _pendingMessagesContext;
}


#pragma mark - Public

- (void)sendPostInChannel:(KGChannel *)channel
                  message:(NSString *)message
              attachments:(NSArray<UIImage *> *)attachments
               completion:(void (^)(KGPost *, KGError *))completion
                 progress:(void (^)(NSUInteger))progress
{
    __block KGPost* postToSend = [KGPost MR_createEntityInContext:self.pendingMessagesContext];
    __block KGError *postError = nil;
    
    [self uploadAttachmentsIfNeeded:attachments channel:channel completion:^(NSArray *files, KGError *error) {
        if (error) {
            postError = error;
            return;
        }

        [self configurePost:postToSend message:message channel:channel attachments:files];

        [self.pendingMessagesContext performBlockAndWait:^{
            [self.pendingMessagesContext MR_saveOnlySelfAndWait];
        }];


        [[KGBusinessLogic sharedInstance] sendPost:postToSend completion:^(KGError *error) {
            if (completion) {
                completion(postToSend, error);
            }
        }];
    } progress:^(NSUInteger persentValue) {
        if (progress) {
            progress(persentValue);
        }
    }];
}


#pragma mark - Private

- (void)uploadAttachmentsIfNeeded:(NSArray *)attachments
                          channel:(KGChannel *)channel
           completion:(void(^)(NSArray *files, KGError *error))completion
                         progress:(void(^)(NSUInteger persentValue))progress {
                    if (attachments) {
                        dispatch_group_t group = dispatch_group_create();
                        __block KGError *imageError = nil;
                        __block NSMutableArray *filesArray = [NSMutableArray array];
                        
                        for (UIImage *image in attachments) {
                            dispatch_group_enter(group);
                            [[KGBusinessLogic sharedInstance] uploadImage:[image kg_normalizedImage]
                                                                atChannel:channel
                                                           withCompletion:^(KGFile* file, KGError* error) {
                                                               if (error) {
                                                                   imageError = error;
                                                                   return;
                                                               }
                                                               KGFile *file_ = [KGFile MR_findFirstByAttribute:[KGFileAttributes backendLink]
                                                                                                     withValue:file.backendLink
                                                                                                     inContext:self.pendingMessagesContext];
                                                               [filesArray addObject:file_];
                                                               dispatch_group_leave(group);
                                                           } progress:^(NSUInteger persentValue) {
                                                               if (progress) {
                                                                   progress(persentValue);
                                                               }
                                                           }];
                        }
                        
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(filesArray, imageError);
                            }
                        });
                    } else {
                        if (completion) {
                            completion(nil, nil);
                        }
                    }
}

- (void)assignFiles:(NSArray *)files toPost:(KGPost *)post {
    [post addFiles:[NSSet setWithArray:files]];
}


- (void)configurePost:(KGPost *)postToSend
              message:(NSString *)message
              channel:(KGChannel *)channel
          attachments:(NSArray *)attachments {
                [self.pendingMessagesContext performBlockAndWait:^{
                    postToSend.message = message;
                    KGUser *author = [KGUser MR_findFirstByAttribute:@"identifier"
                                                           withValue:[[KGBusinessLogic sharedInstance] currentUserId]
                                                           inContext:self.pendingMessagesContext];
                    postToSend.author = author;
                    postToSend.channel = [channel MR_inContext:self.pendingMessagesContext];
                    postToSend.createdAt = [NSDate date];
                    if (attachments) {
                        [self assignFiles:attachments toPost:postToSend];
                    }
                    [postToSend configureBackendPendingId];
                }];
}

@end
