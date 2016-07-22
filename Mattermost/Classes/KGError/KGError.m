//
//  KGError.m
//  Toldot
//
//  Created by Admin on 22/09/15.
//  Copyright (c) 2015 Kilo. All rights reserved.
//

#import "KGError.h"
#import <RestKit.h>

static NSString *const KGErrorDefaultTitle = @"Ошибка";
static NSString *const KGErrorDefaultMessage = @"Неизвестная ошибка, свяжитесь с разработчиком для ее устранения";
static NSString *const KGErrorServerInternalTitle = @"Внутренняя ошибка сервера";
static NSString *const KGErrorServerInternalMessage = @"Повторите позже";


@implementation KGError

#pragma mark - init

- (instancetype)initWithNSError:(NSError *)error {
    self = [super init];
    if (self) {
        self.code = @(error.code);
        self.message = error.localizedDescription;
        
        NSData *data = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *message = messageDict[@"message"];
            if (message) {
                self.message = message;
            }
        }
    }
    
    return self;
}

+ (instancetype) errorWithCode:(KGErrorCode) code title:(NSString*)title message:(NSString*) message {
    KGError* error = [[KGError alloc] init];
    if(error) {
        error.message = message;
        error.code = @(code);
        error.title = title;
    }
    return error;
}

+ (instancetype)errorWithNSError:(NSError *)error {
    if (!error){
        return nil;
    }
    
    KGError *kg_error = error.userInfo[RKObjectMapperErrorObjectsKey][0];
    if (!kg_error) {
        NSHTTPURLResponse *response = error.userInfo[AFRKNetworkingOperationFailingURLResponseErrorKey];
        if (response.statusCode == 500) {
            kg_error = [KGError errorWithCode:response.statusCode title:KGErrorServerInternalTitle message:KGErrorServerInternalMessage];
        }
    }
    if (!kg_error) {
        return [[KGError alloc] initWithNSError:error];
    }
    return kg_error;

}

#pragma mark - Mapping

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[KGError class]];
    [errorMapping addAttributeMappingsFromArray:@[ @"solution", @"title" ]];
    [errorMapping addAttributeMappingsFromDictionary:@{ @"status" : @"code",
                                                        @"detail" : @"message" }];
    
    return errorMapping;
}

+ (RKResponseDescriptor *)responseDescriptor {
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self objectMapping]
                                                                                                 method:RKRequestMethodAny
                                                                                            pathPattern:nil
                                                                                                keyPath:nil
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    return errorResponseDescriptor;
}


#pragma mark - Pre-defined errors

KGError *cannotOpenFileError() {
    return [KGError errorWithCode:KGErrorCannotOpenFile
                            title:NSLocalizedString(@"File format is not supported", nil)
                          message:@"File format is not supported"];
}

KGError *fileDoesntExsistError() {
    return [KGError errorWithCode:KGErrorCannotOpenFile
                            title:NSLocalizedString(@"File doesnt exist", nil)
                          message:@"File doesnt exist"];

}

@end
