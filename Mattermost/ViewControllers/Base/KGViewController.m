//
//  KGViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"
#import "KGChatNavigationController.h"
#import <MFSideMenu/MFSideMenu.h>

@interface KGViewController () <UINavigationControllerDelegate>

@end

@implementation KGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self test];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        self.navigationController.delegate = nil;
    }
}



#pragma mark - Progress

- (void)showProgressHud {
    [[KGAlertManager sharedManager] showProgressHud];
}

- (void)hideProgressHud {
    [[KGAlertManager sharedManager] hideHud];
}


#pragma mark - Error processing

- (void)processError:(KGError *)error {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] ;
    [alert show];
}

- (void)processErrorWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil, nil];
    [alert show];
}

- (void)test {
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[KGChatNavigationController class]]) {
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
        //                                                                                 style:UIBarButtonItemStylePlain
        //                                                                                target:nil
        //                                                                                action:nil];
        
        if (navigationController.viewControllers.count == 1 /*&& ![self isModal]*/) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(toggleLeftSideMenuAction)];
        }
        
    }
}


#pragma mark - Actions

- (void)toggleLeftSideMenuAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


@end
