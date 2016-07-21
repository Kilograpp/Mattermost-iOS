//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@class UIImage;
@class KGFile;
@class KGChannel;

@interface KGBusinessLogic (File)

- (void)updateFileInfo:(KGFile*)file withCompletion:(void(^)(KGError *error))completion;
- (void)uploadImage:(UIImage*)image
          atChannel:(KGChannel*)channel
     withCompletion:(void(^)(KGFile* file, KGError *error))completion
           progress:(void(^)(NSUInteger persentValue))progress;

- (NSURL *)downloadLinkForFile:(KGFile *)file;
- (NSURL *)thumbLinkForFile:(KGFile*)file;

- (void)downloadFile:(KGFile *)file
            progress:(void(^)(NSUInteger persentValue))progress
          completion:(void (^)(KGError *error))completion;

@end