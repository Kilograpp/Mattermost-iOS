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

@interface KGSideMenuContainerViewController ()
@property (nonatomic, assign) CGFloat *oldX;
@end

@implementation KGSideMenuContainerViewController

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
    return UIStatusBarStyleLightContent;
}

+ (instancetype)configuredContainerViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *navController = [sb instantiateInitialViewController];
    KGLeftMenuViewController *leftMenuViewController = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([KGLeftMenuViewController class])];
    KGSideMenuContainerViewController *sideMenuContainer = [KGSideMenuContainerViewController containerWithCenterViewController:navController
                                                                                                         leftMenuViewController:leftMenuViewController
                                                                                                        rightMenuViewController:[UITabBarController new]];
    sideMenuContainer.leftMenuWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - KGLeftMenuOffset;
    sideMenuContainer.menuAnimationDefaultDuration = KGStandartAnimationDuration;
    sideMenuContainer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    return sideMenuContainer;
}


#pragma mark - Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
