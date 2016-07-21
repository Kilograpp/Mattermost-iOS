//
//  KGAlertStrategy.m
//  Envolved
//
//  Created by Maxim Gubin on 07/12/15.
//  Copyright © 2015 Kilograpp. All rights reserved.
//

#import "KGAlertManager.h"
#import "UIWindow+KGAdditions.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "KGAlertView.h"

static CGFloat const kHUDDimViewAlpha = 0.4f;
static CGFloat const kHUDDismissDelay = 1.2f;
static CGFloat const kStandartHudDismissDelay = 4.0f;


@interface KGAlertManager ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign, getter=isHudHidden) BOOL hudHidden;
@property (nonatomic, retain) KGAlertView *alertView;

@property (assign) BOOL alertHidden;
@end

@implementation KGAlertManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _hudHidden = YES;
    }
    return self;
}

- (instancetype)init {
    self = nil;
    NSAssert(false, @"use +sharedManager instead!");
    return self;
}

- (void)showProgressHud {
    [self hideHudAnimated:NO];
    self.hud = [MBProgressHUD showHUDAddedTo:self.presentingViewController.view animated:YES];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kHUDDimViewAlpha];
    self.hudHidden = NO;
}

- (void)showUploadProgressHudWithProgressBlock:(void(^)(NSUInteger persentValue))progress{
    [self hideHudAnimated:NO];
    self.hud = [MBProgressHUD showHUDAddedTo:self.presentingViewController.view animated:YES];
    self.hud.removeFromSuperViewOnHide = YES;
//    self.hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kHUDDimViewAlpha]
    
    // Set the annular determinate mode to show task progress.
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = NSLocalizedString(@"Loading...", @"HUD loading title");
    self.hudHidden = NO;
}

- (void)hideHud {
    [self hideHudAnimated:YES];
}

- (void)showSuccessHud {
    [self showSuccessHudWithMessage:NSLocalizedString(@"Успех!", nil)];
}

- (void)showSuccessHudWithMessage:(NSString *)message {
    [self.hud hide:YES];
    self.hud = [MBProgressHUD showHUDAddedTo:self.presentingViewController.view.window animated:YES];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hudHidden = NO;
    self.hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    self.hud.detailsLabelText = message;
    [self hideHudAnimated:YES afterDelay:kHUDDismissDelay];
}

- (void)showError:(KGError *)error {
    self.alertView = [[KGAlertView alloc] initWithType:KGAlertTypeError
                                               message:NSLocalizedString(error.message, nil)
                                              duration:kStandartHudDismissDelay
                                              callback:nil];
    self.alertView.presentingViewController = [self presentingViewController].navigationController;
    [self.alertView showAlertViewAnimated:YES];
}

- (void)showSuccessWithMessage:(NSString *)message {
//    self.alertView = [KGAlertView sharedMessage];
//    [self.alertView showAlertViewWithMessage:message
//                                      withType:KGAlertTypeSuccess
//                                  withDuration:kStandartHudDismissDelay
//                                  withCallback:nil];
}

- (void)showErrorWithMessage:(NSString *)message {
    self.alertView = [[KGAlertView alloc] initWithType:KGAlertTypeError
                                               message:NSLocalizedString(message, nil)
                                              duration:kStandartHudDismissDelay
                                              callback:nil];
    [self.alertView showAlertViewAnimated:YES];
}


- (void)showUnauthorizedError {
//    self.alertView = [KGAlertView sharedMessage];
//    [self.alertView showAlertViewWithMessage:NSLocalizedString(@"Недоступно для неавторизованного пользователя", nil)
//                                      withType:KGAlertTypeError
//                                  withDuration:kStandartHudDismissDelay
//                                  withCallback:nil];
}

- (void)showWarningWithMessage:(NSString *)message {
    if (self.alertView) {
        [self.alertView hideAlertViewAnimated:NO];
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }
    self.alertView = [[KGAlertView alloc] initWithType:KGAlertTypeWarning
                                               message:NSLocalizedString(message, nil)
                                              duration:kStandartHudDismissDelay
                                              callback:^{
                                                  //todo
                                              }];
    self.alertView.presentingViewController = [self presentingViewController];
    [self.alertView showAlertViewAnimated:YES];
}

- (void)hideWarning {
    if (self.alertView) {
        [self.alertView hideAlertViewAnimated:YES];
    }
}

#pragma mark - Private

- (UIViewController *)presentingViewController {
    if (!_presentingViewController) {
        
        return [UIWindow kg_visibleViewController];
    }
    return _presentingViewController;
}


- (void)hideHudAnimated:(BOOL)animated {
    [self.hud hide:animated];
    self.hudHidden = YES;
}

- (void)hideHudAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self.hud hide:animated afterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hudHidden = YES;
    });
}

//- (void)showDefaultAlertWithTitle:(NSString *)title message:(NSString *)message actionBlock:(void(^)())actionBlock {
//    SDCAlertController *alertController = [[SDCAlertController alloc] initWithTitle:title
//                                                                            message:message
//                                                                     preferredStyle:AlertControllerStyleAlert];
//
//    SDCAlertAction *action = [[SDCAlertAction alloc] initWithTitle:@"OK" style:AlertActionStylePreferred handler:actionBlock];
//    [alertController addAction:action];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.hud.alpha = 0;
//    });
//    [self.presentingViewController presentViewController:alertController animated:self.isHudHidden completion:^{
//        [self hideHudAnimated:NO];
//    }];
//}



@end
