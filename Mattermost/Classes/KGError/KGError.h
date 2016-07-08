 //
//  KGError.h
//  Toldot
//
//  Created by Admin on 22/09/15.
//  Copyright (c) 2015 Kilo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+KGError.h"

@class RKResponseDescriptor;

typedef NS_ENUM(NSInteger, KGErrorCode) {
    KGErrorCodeAuthorizationFailed = 1,
    KGOperationCancelledError = 2,
    KGErrorCodeExpiredSession = 6,
    KGErrorCodeUI = 7,
    KGErrorCodeNoConnection = -1009,
    KGErrorCannotOpenFile = 10000,
    KGErrorFileDoesntExsist = 10001
};

@interface KGError : NSObject

@property (strong, nonatomic) NSNumber *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *solution;
@property (nonatomic, copy) NSDictionary *userInfo;

+ (RKResponseDescriptor *)responseDescriptor;

+ (instancetype)errorWithNSError:(NSError *)error;
+ (instancetype) errorWithCode:(KGErrorCode) code title:(NSString*)title message:(NSString*) message;


KGError *cannotOpenFileError();
KGError *fileDoesntExsistError();

@end
