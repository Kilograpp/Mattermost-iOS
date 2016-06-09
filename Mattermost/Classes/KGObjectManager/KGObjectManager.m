//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGObjectManager.h"
#import "KGError.h"
#import "KGUtils.h"


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
                success:(void (^)(RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure{
    [self getObjectsAtPath:path parameters:nil success:success failure:failure];
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

#pragma mark - Support

- (KGError*)handleOperation:(RKObjectRequestOperation *)operation withError:(NSError *)error{
   return [KGError errorWithNSError:error];
}

@end