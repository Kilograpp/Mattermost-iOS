//
// Created by Maxim Gubin on 11/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <SOCKit/SOCKit.h>
#import "KGBusinessLogic+File.h"
#import "KGFile.h"
#import "KGObjectManager.h"
#import "KGUtils.h"


@implementation KGBusinessLogic (File)

- (NSURL *)downloadLinkForFile:(KGFile *)file {
    NSString* pathPattern = SOCStringFromStringWithObject([KGFile downloadLinkPathPattern], file);
    return [self.defaultObjectManager.HTTPClient.baseURL URLByAppendingPathComponent:pathPattern];
}


- (NSURL *)thumbLinkForFile:(KGFile*)file {
    NSString* pathPattern = SOCStringFromStringWithObject([KGFile thumbLinkPathPattern], file);
    return [self.defaultObjectManager.HTTPClient.baseURL URLByAppendingPathComponent:pathPattern];
}

- (void)updateFileInfo:(KGFile*)file withCompletion:(void(^)(KGError *error))completion {
    NSString* path = SOCStringFromStringWithObject([KGFile updatePathPattern], file);
    [self.defaultObjectManager getObjectsAtPath:path success:^(RKMappingResult *mappingResult) {
        safetyCall(completion, nil);
    } failure:completion];
}

@end