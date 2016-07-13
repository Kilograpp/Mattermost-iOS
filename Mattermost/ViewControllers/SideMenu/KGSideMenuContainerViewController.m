//
//  KGSideMenuContainerViewController.m
//  Envolved
//
//  Created by Dmitry Arbuzov on 19/01/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGSideMenuContainerViewController.h"
#import "KGNavigationController.h"
#import "KGConstants.h"
#import "KGLeftMenuViewController.h"
#import "KGRightMenuViewController.h"
#import "UIStatusBar+SharedBar.h"
#import "KGAlertManager.h"

@interface KGSideMenuContainerViewController ()
@end

@implementation KGSideMenuContainerViewController

#pragma mark - Init

+ (instancetype)containerWithCenterViewController:(id)centerViewController
                           leftMenuViewController:(id)leftMenuViewController
                          rightMenuViewController:(id)rightMenuViewController {
    KGSideMenuContainerViewController *controller = [KGSideMenuContainerViewController new];
    controller.leftMenuViewController = leftMenuViewController;
    controller.centerViewController = centerViewController;
    controller.rightMenuViewController = rightMenuViewController;

    return controller;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


+ (instancetype)configuredContainerViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *navController = [sb instantiateInitialViewController];
    KGLeftMenuViewController *leftMenuViewController = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([KGLeftMenuViewController class])];
    KGRightMenuViewController *rightMenuViewController = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([KGRightMenuViewController class])];
    KGSideMenuContainerViewController *sideMenuContainer = [KGSideMenuContainerViewController containerWithCenterViewController:navController
                                                                                                         leftMenuViewController:leftMenuViewController
                                                                                                        rightMenuViewController:rightMenuViewController];
    sideMenuContainer.leftMenuWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - KGLeftMenuOffset;
    sideMenuContainer.menuAnimationDefaultDuration = KGStandartAnimationDuration;
    sideMenuContainer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    return sideMenuContainer;
}


#pragma mark - Override

- (void)setMenuState:(MFSideMenuState)menuState completion:(void (^)(void))completion {

    [super setMenuState:menuState completion: ^{
        [[KGAlertManager sharedManager]hideWarning];
        if (completion) {
            completion();
        }
    }];
}

- (void)toogleStatusBarState {
//    BOOL isStatusBarHidden = self.menuState == MFSideMenuStateClosed;
//    [self reverseStatusBarIsStatusBarHidden:isStatusBarHidden];
   
//    BOOL isStatusBarHidden = self.menuState == MFSideMenuStateClosed;
//    [[UIApplication sharedApplication] setStatusBarHidden:!isStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
    
  }

- (void)reverseStatusBarIsStatusBarHidden:(BOOL)isStatusBarHidden {
    if (!isStatusBarHidden) {
        [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelStatusBar + 1;
    } else {
        [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelStatusBar - 1 ;
    }
}

#pragma mark - Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
