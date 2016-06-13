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

- (void)uploadImage:(UIImage*)image atChannel:(KGChannel*)channel withCompletion:(void(^)(NSString* fileName, KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGFile uploadFilePathPattern], [self currentTeam]);
    NSDictionary* parameters = @{
            @"channel_id" : channel.identifier,
            @"client_ids" : [NSStringUtils randomUUID]
    };
    [self.defaultObjectManager postImage:image withName:@"files" atPath:path parameters:parameters success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, [mappingResult.firstObject name], nil);
    } failure:^(KGError *error) {
        safetyCall(completion, nil, error);
    }];
}

@end