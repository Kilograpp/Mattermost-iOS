//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//



#import "KGObjectManager.h"
#import <RestKit/RKManagedObjectRequestOperation.h>
#import "KGError.h"
#import "KGUtils.h"
#import <MagicalRecord/MagicalRecord.h>


@implementation KGObjectManager

#pragma mark - GET

-(void)getObjectsAtPath:(NSString *)path
        parameters:(NSDictionary *)parameters
        success:(void (^)(RKMappingResult *mappingResult))success
        failure:(void (^)(KGError *error))failure{
    [self getObject:nil path:path parameters:parameters useCache:YES savesToStore:YES success:success failure:failure];
}


-(void)getObjectsAtPath:(NSString *)path
             parameters:(NSDictionary *)parameters
   successWithOperation:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure{
    [super getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, operation, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    }];
}
- (void)getObjectsAtPath:(NSString *)path
            savesToStore:(BOOL)savesToPersistentStore
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self getObject:nil path:path parameters:nil useCache:YES savesToStore:savesToPersistentStore success:success failure:failure];
}

- (void)getObjectsAtPath:(NSString *)path
                success:(void (^)(RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure{
    [self getObjectsAtPath:path parameters:nil success:success failure:failure];
}

- (void)getObjectsAtPath:(NSString *)path
                useCache:(BOOL)useCache
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self getObject:nil path:path parameters:nil useCache:useCache savesToStore:YES success:success failure:failure];
}

- (void)getObjectsAtPath:(NSString *)path
                useCache:(BOOL)useCache
            savesToStore:(BOOL)savesToStore
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self getObject:nil path:path parameters:nil useCache:useCache savesToStore:savesToStore success:success failure:failure];
}


- (void)getObject:(id)object
             path:(NSString*)path
     savesToStore:(BOOL)savesToPersistentStore
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure{
    [self getObject:nil path:path parameters:nil useCache:YES savesToStore:savesToPersistentStore success:success failure:failure];
}

- (void)getObject:(id)object
             path:(NSString*)path
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure{
    [self getObject:object path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    }];
}

- (void)getObject:(id)object
             path:(NSString*)path
       parameters:(NSDictionary*)parameters
         useCache:(BOOL)useCache
     savesToStore:(BOOL)savesToStore
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure{
    
    void (^successHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    };
    
    void (^failureHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    };
    
    NSMutableURLRequest* request = [self requestWithObject:object method:RKRequestMethodGET path:path parameters:parameters];
    if (!useCache){
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    RKManagedObjectRequestOperation* operation = [self managedObjectRequestOperationWithRequest:request
                                                                           managedObjectContext:[object managedObjectContext]
                                                                                        success:successHandlerBlock
                                                                                        failure:failureHandlerBlock];
    operation.savesToPersistentStore = savesToStore;
    
    
    [self enqueueObjectRequestOperation:operation];
}

#pragma mark - POST

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure{
    [super postObject:object path:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    }];
}

- (void)postObject:(id)object
              path:(NSString *)path
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure{
    [self postObject:object path:path parameters:nil success:success failure:failure];
}

- (void)postObjectAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self postObject:nil path:path parameters:parameters success:success failure:failure];
}

- (void)postObjectAtPath:(NSString *)path
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self postObject:nil path:path parameters:nil savesToStore:NO success:success failure:failure];
}

- (void)postObjectAtPath:(NSString *)path
            savesToStore:(BOOL)savesToStore
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure{
    [self postObject:nil path:path parameters:nil savesToStore:savesToStore success:success failure:failure];
}


- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary*)parameters
      savesToStore:(BOOL)savesToPersistentStore
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure {
    
    void (^successHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    };
    
    void (^failureHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    };
    
    
    
    NSURLRequest* request = [self requestWithObject:object method:RKRequestMethodPOST path:path parameters:parameters ];
    RKManagedObjectRequestOperation* operation = [self managedObjectRequestOperationWithRequest:request
                                                                           managedObjectContext:[object managedObjectContext]
                                                                                        success:successHandlerBlock
                                                                                        failure:failureHandlerBlock];
    operation.savesToPersistentStore = savesToPersistentStore;
    
    [self enqueueObjectRequestOperation:operation];
}

- (void)postImage:(UIImage*)image
         withName:(NSString*)name
           atPath:(NSString*)path
       parameters:(NSDictionary*)parameters
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure
         progress:(void(^)(NSUInteger persentValue))progress
{
    void (^constructingBodyWithBlock)(id <AFRKMultipartFormData>) = ^void(id <AFRKMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:name fileName:@"file.png" mimeType:@"image/png"];
    };

    NSMutableURLRequest *request = [self multipartFormRequestWithObject:nil
                                                                 method:RKRequestMethodPOST
                                                                   path:path
                                                             parameters:parameters
                                              constructingBodyWithBlock:constructingBodyWithBlock];

    void (^successHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    };

    void (^failureHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    };

    RKObjectRequestOperation *operation = [self objectRequestOperationWithRequest:request
                                                                          success:successHandlerBlock
                                                                          failure:failureHandlerBlock];
    
    
    [operation.HTTPRequestOperation setUploadProgressBlock:
     ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
         if (progress) {
             NSInteger progressValue = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite * 100;
             progress(progressValue);
         }
     }];

    [self enqueueObjectRequestOperation:operation];
}

#pragma mark - Support

- (KGError*)handleOperation:(RKObjectRequestOperation *)operation withError:(NSError *)error{
   return [KGError errorWithNSError:error];
}

@end