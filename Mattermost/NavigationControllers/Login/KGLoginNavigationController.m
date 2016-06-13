//
//  KGLoginNavigationController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGLoginNavigationController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGLoginViewController.h"

@interface KGLoginNavigationController ()

@end

@implementation KGLoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    UINavigationBar *navBar = self.navigationBar;
    navBar.translucent = YES;
    
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.tintColor = [UIColor kg_blackColor];
    navBar.backgroundColor = [UIColor clearColor];
    navBar.topItem.title = @"";
        [self.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                       NSFontAttributeName : [UIFont kg_semibold18Font] }];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.topViewController isKindOfClass:[KGLoginViewController class]]) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (UIColor *)kg_barTintColor {
    if ([self.topViewController isKindOfClass:[KGLoginViewController class]]) {
        return [UIColor kg_whiteColor];
    }
    return [UIColor kg_blackColor];
}

@end
