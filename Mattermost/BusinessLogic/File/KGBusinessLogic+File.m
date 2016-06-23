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
    NSDictionary* parameters = @{
            @"channel_id" : channel.identifier,
            @"client_ids" : [NSStringUtils randomUUID]
    };
    [self.defaultObjectManager postImage:image withName:@"files" atPath:path parameters:parameters success:^(RKMappingResult *mappingResult) {

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


//- (void)downloadFile:(KGFile *)file withCompletion:(void(^)(NSURL* localUrl, KGError *error))completion {
//    RKObjectManager *manager = [RKObjectManager sharedManager];
// 
//    NSMutableURLRequest *downloadRequest = [manager requestWithObject:request method:RKRequestMethodPOST path:file.downloadLink.absoluteString parameters:nil];
//    AFHTTPRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:downloadRequest];
//    
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // Use my success callback with the binary data and MIME type string
//        callback(operation.responseData, operation.response.MIMEType, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // Error callback
//        callback(nil, nil, error);
//    }];
//    [manager.HTTPClient enqueueHTTPRequestOperation:requestOperation];
//}


- (void)downloadFile:(KGFile *)file progress:(void(^)(NSUInteger, long long , long long ))onProgress success:(void (^)(id))onSuccess error:(void (^)(NSError *))onError
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:file.downloadLink];
    AFHTTPRequestOperation *operation = [self.defaultObjectManager.HTTPClient HTTPRequestOperationWithRequest:request
                                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                 
//                                                                                 NSURL *url = [NSURL fileURLWithPath:aPath];
                                                                                 NSError *error;
//                                                                                 [self skipBackupForURL:url error:&error];
                                                                                 onSuccess(self);
                                                                                 
                                                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                 onError(error);
                                                                             }];
    [operation setDownloadProgressBlock:onProgress];
    
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:aPath
//                                                               append:NO];
    [operation start];
}

- (void)skipBackupForURL:(NSURL *)anURL error:(NSError **)anError
{
    [anURL setResourceValue:[NSNumber numberWithBool:YES]
                     forKey:NSURLIsExcludedFromBackupKey error:anError];
}

@end