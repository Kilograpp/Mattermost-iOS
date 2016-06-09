//
//  KGChatNavigationController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatNavigationController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"

@interface KGChatNavigationController () <UINavigationControllerDelegate>

@end

@implementation KGChatNavigationController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
    [self setupNavigationBar];
}


#pragma mark - Setup

- (void)setupNavigationBar {
    UINavigationBar *navBar = self.navigationBar;
    navBar.translucent = YES;
    
    navBar.tintColor = [UIColor kg_whiteColor];
    navBar.barTintColor = [UIColor kg_blueColor];
    [self.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                   NSFontAttributeName : [UIFont kg_semibold18Font] }];
    
}


#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
