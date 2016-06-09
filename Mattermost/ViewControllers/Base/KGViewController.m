//
//  KGViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"


@interface KGViewController ()

@end

@implementation KGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self test];
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

@end
