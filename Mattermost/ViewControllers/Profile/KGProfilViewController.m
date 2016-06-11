//
//  KGProfilViewController.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGProfilViewController.h"

@implementation KGProfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
}

- (void)setupNavigationBar{
    self.title = @"Профиль";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close_icon"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backAction)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void) backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
