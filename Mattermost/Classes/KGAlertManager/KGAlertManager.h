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
//- (void)showSuccessHud;
//- (void)showSuccessHudWithMessage:(NSString *)message;
//- (void)showError:(KGError *)error;
//- (void)showError:(KGError *)error withActionBlock:(void(^)())actionBlock;

- (void)showError:(KGError *)error;

- (void)showSuccessWithTitle:(NSString*)title message:(NSString *)message;
- (void)showErrorWithTitle:(NSString*)title message:(NSString *)message;
- (void)showSuccessWithMessage:(NSString *)message;

- (void)showWarningWithTitle:(NSString *)title message:(NSString *)message;

- (void)showUnauthorizedError;

@end
