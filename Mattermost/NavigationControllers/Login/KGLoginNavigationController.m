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


@interface KGLoginNavigationController ()

@end

@implementation KGLoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
//    UINavigationBar *navBar = self.navigationBar;
//    navBar.translucent = YES;
//    
//    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    navBar.shadowImage = [UIImage new];
//    navBar.tintColor = [UIColor kg_blueColor];
//    navBar.backgroundColor = [UIColor clearColor];
    [self.navigationBar setTitleTextAttributes: @{ NSFontAttributeName : [UIFont kg_regular18Font] }];
}

@end
