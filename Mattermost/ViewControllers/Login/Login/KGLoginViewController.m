//
//  KGLoginViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGLoginViewController.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGConstants.h"
#import "KGButton.h"
#import "KGTextField.h"
#import "KGBusinessLogic+Session.h"
#import "NSString+Validation.h"
#import "KGBusinessLogic+Team.h"
#import "KGSideMenuContainerViewController.h"

static NSString *const kShowTeamsSegueIdentifier = @"showTeams";

@interface KGLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPromtLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordPromtLabel;
@property (weak, nonatomic) IBOutlet KGButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *recoveryButton;
@property (weak, nonatomic) IBOutlet KGTextField *loginTextField;
@property (weak, nonatomic) IBOutlet KGTextField *passwordTextField;

@end

@implementation KGLoginViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleLabel];
    [self setupPromtLabels];
    [self setupLoginButton];
    [self setupRecoveryButton];
    [self setupLoginTextfield];
    [self setupPasswordTextField];   
    [self configureLabels];
}

- (void)test {
    self.loginTextField.text = @"getmaxx@kilograpp.com";
    self.passwordTextField.text = @"102Aky5i";
    self.loginButton.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.loginTextField becomeFirstResponder];
}


#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel.font = [UIFont kg_semibold30Font];
    self.titleLabel.textColor = [UIColor kg_blackColor];
}

- (void)setupPromtLabels {
    self.loginPromtLabel.font = [UIFont kg_regular14Font];
    self.loginPromtLabel.textColor = [UIColor kg_grayColor];
    
    self.passwordPromtLabel.font = [UIFont kg_regular14Font];
    self.passwordPromtLabel.textColor = [UIColor kg_grayColor];
}

- (void)setupLoginButton {
    self.loginButton.layer.cornerRadius = KGStandartCornerRadius;
    self.loginButton.backgroundColor = [UIColor kg_blueColor];
    [self.loginButton setTitle:NSLocalizedString(@"Sign in", nil) forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor whiteColor]];
    self.loginButton.titleLabel.font = [UIFont kg_regular16Font];
    self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    self.loginButton.enabled = NO;
}

- (void)setupRecoveryButton {
    self.recoveryButton.layer.cornerRadius = KGStandartCornerRadius;
    self.recoveryButton.backgroundColor = [UIColor kg_whiteColor];
    [self.recoveryButton setTitle:NSLocalizedString(@"I forgot password", nil) forState:UIControlStateNormal];
    [self.recoveryButton setTintColor:[UIColor kg_blueColor]];
    [self.recoveryButton setTitleColor:[UIColor kg_blueColor] forState:UIControlStateNormal];
    self.recoveryButton.titleLabel.font = [UIFont kg_regular16Font];
}

- (void)setupLoginTextfield {

    self.loginTextField.delegate = self;
    self.loginTextField.textColor = [UIColor kg_blackColor];
    self.loginTextField.font = [UIFont kg_regular16Font];
    self.loginTextField.placeholder = @"address@example.com";
    self.loginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.loginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)setupPasswordTextField {

    self.passwordTextField.delegate = self;
    self.passwordTextField.textColor = [UIColor kg_blackColor];
    self.passwordTextField.font = [UIFont kg_regular16Font];
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.secureTextEntry = YES;
}


#pragma mark - Configuration

- (void)configureLabels {
    self.titleLabel.text = @"Team name";
    self.loginPromtLabel.text = @"Email";
    self.passwordPromtLabel.text = @"Password";
}


#pragma mark - Actions

- (IBAction)loginAction:(id)sender {
    if ([self.loginTextField.text kg_isValidEmail]){
        [self login];
    } else {
        [self processErrorWithTitle:@"Error" message:@"Incorrect email address format"];
    }
}

- (IBAction)recoveryAction:(id)sender {
}

- (IBAction)loginChangeAction:(id)sender {
    if (self.loginTextField.text.length > 0 & self.passwordTextField.text.length > 0) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}
- (IBAction)passwordChangeAction:(id)sender {
    if (self.loginTextField.text.length > 0 & self.passwordTextField.text.length > 0) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

#pragma mark - Requests

- (void)login {
    NSString *login = self.loginTextField.text;
    NSString *password = self.passwordTextField.text;
    [self showProgressHud];
    
    [[KGBusinessLogic sharedInstance] loginWithEmail:login password:password completion:^(KGError *error) {
        [self hideProgressHud];
        if (error) {
            [self processError:error];
            [self highlightTextFieldsForError];
        }
        else {
            [[KGBusinessLogic sharedInstance] loadTeamsWithCompletion:^(BOOL userShouldSelectTeam, KGError *error) {
                if (error) {
                    [self processError:error];
                } else if (!userShouldSelectTeam) {
                    [self performSegueWithIdentifier:kShowTeamsSegueIdentifier sender:nil];
                } else {
                    KGSideMenuContainerViewController *vc = [KGSideMenuContainerViewController configuredContainerViewController];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }];
        }
    }];
}


@end
