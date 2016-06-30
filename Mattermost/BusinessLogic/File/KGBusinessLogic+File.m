//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <SOCKit/SOCKit.h>
#import "KGBusinessLogic+File.h"
#import "KGFile.h"
#import "KGObjectManager.h"
#import "KGUtils.h"
#import "KGTeam.h"
#import "KGBusinessLogic+Team.h"
#import "_KGChannel.h"
#import "KGChannel.h"
#import "NSStringUtils.h"
#import "SDImageCache.h"
#import <MagicalRecord.h>
#import "KGPreferences.h"
#import "UIImage+Resize.h"

@implementation KGBusinessLogic (File)

- (NSURL *)downloadLinkForFile:(KGFile *)file {
    NSString* pathPattern = SOCStringFromStringWithObject([KGFile downloadLinkPathPattern], file);
    return [self.defaultObjectManager.HTTPClient.baseURL URLByAppendingPathComponent:[pathPattern stringByRemovingPercentEncoding]];
}


- (NSURL *)thumbLinkForFile:(KGFile*)file {
    NSString* pathPattern = SOCStringFromStringWithObject([KGFile thumbLinkPathPattern], file);
    return [self.defaultObjectManager.HTTPClient.baseURL URLByAppendingPathComponent:[pathPattern stringByRemovingPercentEncoding]];
}

- (void)updateFileInfo:(KGFile*)file withCompletion:(void(^)(KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGFile updatePathPattern], file);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

- (void)uploadImage:(UIImage*)image atChannel:(KGChannel*)channel withCompletion:(void(^)(KGFile* file, KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGFile uploadFilePathPattern], [self currentTeam]);
    UIImage *finalImage = [KGPreferences sharedInstance].shouldCompressImages ? image : [image kg_resizedImageWithSize:CGSizeMake(image.size.width * 0.25, image.size.height * 0.25)];
    NSDictionary* parameters = @{
            @"channel_id" : channel.identifier,
            @"client_ids" : [NSStringUtils randomUUID]
    };
    [self.defaultObjectManager postImage:finalImage withName:@"files" atPath:path parameters:parameters success:^(RKMappingResult *mappingResult) {

        KGFile *imageFile = [KGFile MR_createEntity];
        [imageFile setBackendLink:[[mappingResult.dictionary[@"filenames"] firstObject] valueForKey:@"backendLink"]];
        NSLog(@"URL %@", imageFile.downloadLink.absoluteString);
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageFile.downloadLink.absoluteString];

        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

        safetyCall(completion, imageFile, nil);
    } failure:^(KGError* error) {
        safetyCall(completion, nil, error);
    }];
}


- (void)downloadFile:(KGFile *)file
            progress:(void(^)(NSUInteger persentValue))progress
          completion:(void (^)(KGError *error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:file.downloadLink];
    [request setHTTPMethod:@"GET"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [file.downloadLink lastPathComponent];
    NSString *filePath = [paths[0] stringByAppendingPathComponent:file.name];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *fullPath = [paths[0] stringByAppendingPathComponent:fileName];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if(progress) {
            progress(totalBytesRead/totalBytesExpectedToRead * 100.0f);
        }
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *trimmedFilePath = [[filePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
        NSString *filePathLastComponent = [@"/" stringByAppendingString:fileName.lastPathComponent];
        NSString *finalFilePath = [trimmedFilePath stringByAppendingString:filePathLastComponent];
        
        file.localLink = finalFilePath;
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        if(completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(completion) {
            completion([KGError errorWithNSError:error]);
        }
    }];

    [operation start];
}

@end