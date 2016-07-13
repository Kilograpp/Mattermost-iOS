//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//


#import <RestKit/CoreData/RKCoreData.h>
#import "KGObjectManager.h"
#import <RestKit/Network/RKManagedObjectRequestOperation.h>
#import "KGError.h"
#import "KGUtils.h"
#import <MagicalRecord.h>


@implementation KGObjectManager

#pragma mark - GET

-(void)getObjectsAtPath:(NSString *)path
        parameters:(NSDictionary *)parameters
        success:(void (^)(RKMappingResult *mappingResult))success
        failure:(void (^)(KGError *error))failure{
    [super getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    }];
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
                success:(void (^)(RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure{
    [self getObjectsAtPath:path parameters:nil success:success failure:failure];
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
    [self postObject:nil path:path parameters:nil success:success failure:failure];
}

- (void)postObject:(id)object
              path:(NSString *)path
      savesToStore:(BOOL)savesToPersistentStore
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure {
    
    void (^successHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        safetyCall(success, mappingResult);
    };
    
    void (^failureHandlerBlock) (id, id) = ^void(RKObjectRequestOperation *operation, NSError *error) {
        safetyCall(failure, [self handleOperation:operation withError:error]);
    };
    
    
    
    NSURLRequest* request = [self requestWithObject:object method:RKRequestMethodPOST path:path parameters:nil ];
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
          failure:(void (^)(KGError *error))failure {
    void (^constructingBodyWithBlock)(id <AFMultipartFormData>) = ^void(id <AFMultipartFormData> formData) {
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

    [self enqueueObjectRequestOperation:operation];
}

#pragma mark - Support

- (KGError*)handleOperation:(RKObjectRequestOperation *)operation withError:(NSError *)error{
   return [KGError errorWithNSError:error];
}

@end