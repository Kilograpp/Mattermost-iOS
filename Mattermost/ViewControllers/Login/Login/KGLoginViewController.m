//
//  KGLoginViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <MagicalRecord/MagicalRecord/NSManagedObject+MagicalFinders.h>
#import "KGLoginViewController.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGUser.h"
#import "KGTeam.h"
#import "KGPreferences.h"
#import "KGConstants.h"
#import "KGButton.h"
#import "KGTextField.h"
#import "KGBusinessLogic+Session.h"
#import "NSString+Validation.h"
#import "KGBusinessLogic+Team.h"
#import "KGBusinessLogic+Channel.h"
#import "KGSideMenuContainerViewController.h"
#import "CAGradientLayer+KGPreparedGradient.h"
#import "KGAlertManager.h"
#import "KGBusinessLogic+Commands.h"

static NSString *const kShowTeamsSegueIdentifier = @"showTeams";
static NSString *const kPresentChatSegueIdentifier = @"presentChat";
static NSString *const kShowResetPasswordSegueIdentifier = @"resetPassword";

static dispatch_group_t channelAndAdditionsGroup;

@interface KGLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet KGButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *recoveryButton;
@property (weak, nonatomic) IBOutlet KGTextField *loginTextField;
@property (weak, nonatomic) IBOutlet KGTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic, strong) __block KGError *channelAndAdditionsError;

@end

@implementation KGLoginViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLabels];
    [self setupTitleLabel];
    [self setupLoginButton];
    [self setupRecoveryButton];
    [self setupLoginTextfield];
    [self setupPasswordTextField];
}

- (void)test {
    self.loginButton.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.loginTextField becomeFirstResponder];
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                        NSFontAttributeName : [UIFont kg_semibold18Font] }];
    self.navigationController.navigationBar.tintColor = [UIColor kg_whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.title = @"Sign In";
    CAGradientLayer *bgLayer = [CAGradientLayer kg_blueGradientForNavigationBar];
    bgLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 2.88);
    [bgLayer animateLayerInfinitely:bgLayer];
    [self.navigationView.layer insertSublayer:bgLayer above:0];
    [self.navigationView bringSubviewToFront:self.titleLabel];
    [self setNeedsStatusBarAppearanceUpdate];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel.font = [UIFont kg_bold28Font];
    self.titleLabel.textColor = [UIColor kg_whiteColor];
}

- (void)setupLoginButton {
    self.loginButton.layer.cornerRadius = KGStandartCornerRadius;
    [self.loginButton setTitle:NSLocalizedString(@"Sign in", nil) forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont kg_medium18Font];
    self.loginButton.enabled = NO;
    self.loginButton.shouldDrawImageAtRightSide = YES;
}

- (void)setupRecoveryButton {
    self.recoveryButton.layer.cornerRadius = KGStandartCornerRadius;
    self.recoveryButton.backgroundColor = [UIColor kg_whiteColor];
    [self.recoveryButton setTitle:NSLocalizedString(@"Forgot password?", nil) forState:UIControlStateNormal];
    [self.recoveryButton setTintColor:[UIColor kg_redColor]];
    [self.recoveryButton setTitleColor:[UIColor kg_redColor] forState:UIControlStateNormal];
    self.recoveryButton.titleLabel.font = [UIFont kg_regular16Font];
}

- (void)setupLoginTextfield {
    self.loginTextField.delegate = self;
    self.loginTextField.textColor = [UIColor kg_blackColor];
    self.loginTextField.font = [UIFont kg_regular16Font];
    self.loginTextField.placeholder = @"Email";
    self.loginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.loginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)setupPasswordTextField {
    self.passwordTextField.delegate = self;
    self.passwordTextField.textColor = [UIColor kg_blackColor];
    self.passwordTextField.font = [UIFont kg_regular16Font];
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.secureTextEntry = YES;
}


#pragma mark - Configuration

- (void)configureLabels {
    NSString *siteName = [[KGPreferences sharedInstance] siteName];
    self.titleLabel.text = siteName;
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
    //[self performSegueWithIdentifier:@"resetPassword" sender:nil];
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
        if (error) {
            [self hideProgressHud];
            [self highlightTextFieldsForError];
            [self processError:error];
        } else {
            [self loadTeams];
        }
    }];
}

- (void)loadTeams {
    [[KGBusinessLogic sharedInstance] loadTeamsWithCompletion:^(BOOL userShouldSelectTeam, KGError *error) {
        if (!userShouldSelectTeam) {
            [self setupChannelsAndCommandsGroup];
            [self loadChannels];
            [self loadCommands];
            [self setupDispatchGroup];
        } else {
            [self hideProgressHud];
            [self performSegueWithIdentifier:kShowTeamsSegueIdentifier sender:nil];
        }
    }];
}

- (void)loadChannels {
    dispatch_group_enter(channelAndAdditionsGroup);
    [[KGBusinessLogic sharedInstance] loadChannelsWithCompletion:^(KGError *error) {
        if (error) {
            self.channelAndAdditionsError = error;
        }
        dispatch_group_leave(channelAndAdditionsGroup);
    }];
}

- (void)loadCommands {
    dispatch_group_enter(channelAndAdditionsGroup);
    [[KGBusinessLogic sharedInstance] updateCommandsList:^(KGError *error) {
        if (error) {
            self.channelAndAdditionsError = error;
        }
        
        dispatch_group_leave(channelAndAdditionsGroup);
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordTextField]) {
        [self loginAction:nil];
    }
    
    return YES;
}


#pragma mark - Private

- (void)setupChannelsAndCommandsGroup {
    channelAndAdditionsGroup = dispatch_group_create();
}

//FIXME: REFACTOR ASAP
- (void)setupDispatchGroup {
    dispatch_group_notify(channelAndAdditionsGroup, dispatch_get_main_queue(), ^{
        [self hideProgressHud];
        if (self.channelAndAdditionsError) {
            [self processError:self.channelAndAdditionsError];
        } else {
            KGSideMenuContainerViewController *vc = [KGSideMenuContainerViewController configuredContainerViewController];
            [self presentViewController:vc animated:YES completion:nil];
        }
    });
}

@end
