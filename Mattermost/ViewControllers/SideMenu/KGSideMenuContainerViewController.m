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
    if ([self.centerViewController respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return ((UIViewController *)self.centerViewController).preferredStatusBarStyle;
    }
    return UIStatusBarStyleLightContent;
}

+ (instancetype)configuredContainerViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *navController = [sb instantiateInitialViewController];
    KGSideMenuContainerViewController *sideMenuContainer = [KGSideMenuContainerViewController containerWithCenterViewController:navController
                                                                                                         leftMenuViewController:[UITableViewController new]
                                                                                                        rightMenuViewController:[UITableViewController new]];
    sideMenuContainer.leftMenuWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - KGLeftMenuOffset;
    sideMenuContainer.menuAnimationDefaultDuration = KGStandartAnimationDuration;
    sideMenuContainer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    return sideMenuContainer;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    BOOL shouldAllowPan = NO;
//    
//    if ([self.centerViewController isKindOfClass:[KGNavigationController class]]) {
//        KGNavigationController *navControler = self.centerViewController;
//        KGViewController *topVc = (KGViewController *)navControler.topViewController;
//        if ([topVc isKindOfClass:[KGMapViewController class]]) {
//            shouldAllowPan = YES;
//        }
//    }
//    
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
//        BOOL isHorizontalPanning = fabsf(velocity.x) > fabsf(velocity.y);
//        BOOL isPanDirectionLeft = self.menuState == MFSideMenuStateClosed && velocity.x < 0;
//        if (isPanDirectionLeft) {
//            return shouldAllowPan;
//        }
//        return isHorizontalPanning;
//    }
//    return YES;
//}




@end
