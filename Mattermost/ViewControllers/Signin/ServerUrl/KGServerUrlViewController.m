//
//  KGServerUrlViewController.m
//  Mattermost
//
//  Created by Tatiana on 01/06/16.
//  Copyright © 2016 Tatiana. All rights reserved.
//

#import "KGServerUrlViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface KGServerUrlViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation KGServerUrlViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
     [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
}


#pragma mark - Setup

- (void)setupTextField {
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
