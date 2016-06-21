//
// Created by Maxim Gubin on 09/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@class KGError;

@interface KGObjectManager : RKObjectManager

-(void)getObjectsAtPath:(NSString *)path
             parameters:(NSDictionary *)parameters
                success:(void (^)(RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure;

- (void)getObjectsAtPath:(NSString*)path parameters:(NSDictionary*)parameters successWithOperation:(void (^)(RKObjectRequestOperation* operation, RKMappingResult* mappingResult))success failure:(void (^)(KGError* error))failure;

-(void)getObjectsAtPath:(NSString *)path
                success:(void (^)(RKMappingResult *mappingResult))success
                failure:(void (^)(KGError *error))failure;

- (void)getObject:(id)object
             path:(NSString*)path
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure;


- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure;


- (void)postObject:(id)object
              path:(NSString *)path
           success:(void (^)(RKMappingResult *mappingResult))success
           failure:(void (^)(KGError *error))failure;

- (void)postObjectAtPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure;

- (void)postObjectAtPath:(NSString *)path
                 success:(void (^)(RKMappingResult *mappingResult))success
                 failure:(void (^)(KGError *error))failure;

- (void)postImage:(UIImage*)image
         withName:(NSString*)name
           atPath:(NSString*)path
       parameters:(NSDictionary*)parameters
          success:(void (^)(RKMappingResult *mappingResult))success
          failure:(void (^)(KGError *error))failure;

@end