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
#import <Masonry/Masonry.h>
#import "KGConstants.h"
#import "KGAlertManager.h"

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
    [[KGAlertManager sharedManager] showError:error];
}

- (void)processErrorWithTitle:(NSString *)title message:(NSString *)message {
   KGError *error = [[KGError alloc] init];
    error.title = title;
    error.message = message;
    [[KGAlertManager sharedManager] showError:error];
}

- (void)test {
    
}

#pragma mark - Loading View

- (UIActivityIndicatorView *)loadingActivityIndicator {
    if (!_loadingActivityIndicator) {
        _loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingActivityIndicator.hidesWhenStopped = YES;
    }
    
    return _loadingActivityIndicator;
}

- (void)showLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.loadingView addSubview:self.loadingActivityIndicator];
    [self.loadingActivityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingView);
    }];
    [self.loadingActivityIndicator startAnimating];
}

- (void)hideLoadingViewAnimated:(BOOL)animated {
    CGFloat duration = animated ? KGStandartAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingActivityIndicator stopAnimating];
        [self.loadingView removeFromSuperview];
    }];
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
        
        if (navigationController.viewControllers.count == 1 /*&& ![self isModal]*/) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(toggleRightSideMenuAction)];
        }
        
    }
}




#pragma mark - Actions

- (void)toggleLeftSideMenuAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)toggleRightSideMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}


@end
