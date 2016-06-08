//
//  KGResetPasswordViewController.m
//  Mattermost
//
//  Created by Tatiana on 08/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGResetPasswordViewController.h"
#import "KGButton.h"
#import "KGTextField.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGConstants.h"
#import "NSString+Validation.h"

@interface KGResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet KGTextField *emailTextField;
@property (weak, nonatomic) IBOutlet KGButton *resetButton;

@end

@implementation KGResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleLabel];
    [self setupSubtitleLabel];
    [self setupResetButton];
    [self setupEmailTextfield];
    [self configureLabels];
}


#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel.font = [UIFont kg_semibold30Font];
    self.titleLabel.textColor = [UIColor kg_blackColor];
}

- (void)setupSubtitleLabel {
    self.subtitleLabel.font = [UIFont kg_light18Font];
    self.subtitleLabel.textColor = [UIColor kg_grayColor];
}

- (void)setupResetButton {
    self.resetButton.layer.cornerRadius = KGStandartCornerRadius;
    self.resetButton.backgroundColor = [UIColor kg_blueColor];
    [self.resetButton setTitle:NSLocalizedString(@"Reset my password", nil) forState:UIControlStateNormal];
    [self.resetButton setTintColor:[UIColor whiteColor]];
    self.resetButton.titleLabel.font = [UIFont kg_regular16Font];
    self.resetButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    self.resetButton.enabled = NO;
}

- (void)setupEmailTextfield {
    
    self.emailTextField.delegate = self;
    self.emailTextField.textColor = [UIColor kg_blackColor];
    self.emailTextField.font = [UIFont kg_regular16Font];
    self.emailTextField.placeholder = @"Email";
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}


#pragma mark - Configuration

- (void)configureLabels {
    self.titleLabel.text = @"Password Reset";
    self.subtitleLabel.text = @"To reset your password, enter the email address you used to sign in";
}
- (IBAction)textChange:(id)sender {
    if (self.emailTextField.text.length > 0 ){
        self.resetButton.enabled = YES;
    } else {
        self.resetButton.enabled = NO;
    }
}
- (IBAction)resetButton:(id)sender {
    if (![self.emailTextField.text kg_isValidEmail]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"incorrect email" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] ;
        [alert show];
    }
}
@end
