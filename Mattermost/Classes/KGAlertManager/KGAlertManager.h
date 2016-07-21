//
//  KGAlertStrategy.h
//  Envolved
//
//  Created by Maxim Gubin on 07/12/15.
//  Copyright © 2015 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KGError.h"

@interface KGAlertManager : NSObject

@property (nonatomic, weak) UIViewController *presentingViewController;

+ (instancetype)sharedManager;

- (void)showProgressHud;
- (void)hideHud;

- (void)showSuccessHud;
- (void)showSuccessHudWithMessage:(NSString *)message;
//- (void)showError:(KGError *)error withActionBlock:(void(^)())actionBlock;

- (void)showError:(KGError *)error;
- (void)showSuccessWithMessage:(NSString *)message;
- (void)showErrorWithMessage:(NSString *)message;
- (void)showWarningWithMessage:(NSString *)message;
- (void)showUnauthorizedError;
- (void)hideWarning;

- (void)showUploadProgressHudWithProgressBlock:(void(^)(NSUInteger persentValue))progress;

@end
