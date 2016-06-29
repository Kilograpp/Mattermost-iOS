//
//  KGImagePickerController.m
//  Mattermost
//
//  Created by Tatiana on 21/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImagePickerController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGNavigationController.h"

@interface KGImagePickerController ()

@end

@implementation KGImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


- (void)setup {
    UINavigationBar *navBar = self.navigationBar;

    navBar.tintColor = [UIColor kg_blackColor];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navBar.backgroundColor = [UIColor kg_lightLightGrayColor];
    [self.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor kg_blackColor],
                                                                        NSFontAttributeName : [UIFont kg_semibold18Font] }];
//    self.navigationController.navigationBar.tintColor = [UIColor kg_whiteColor];
    self.navigationBar.translucent = NO;
}
#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
