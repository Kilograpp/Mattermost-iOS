//
//  KGServerUrlViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGServerUrlViewController.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGConstants.h"
#import "KGButton.h"
#import "KGTextField.h"
#import "KGPreferences.h"
#import "KGUtils.h"
#import "NSString+Validation.h"

static NSString *const kShowLoginSegueIdentifier = @"showLoginScreen";

@interface KGServerUrlViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promtLabel;
@property (weak, nonatomic) IBOutlet KGTextField *textField;

@property (weak, nonatomic) IBOutlet KGButton *nextButton;

@end

@implementation KGServerUrlViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupTitleLabel];
    [self setupPromtLabel];
    [self setupNextButton];
    [self setupTextfield];
    [self configureLabels];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];

}

- (void)test {
    self.textField.text = @"https://mattermost.kilograpp.com";
    self.nextButton.enabled = YES;
}


#pragma mark - Setup 

- (void)setupTitleLabel {
    self.titleLabel.font = [UIFont kg_semibold30Font];
    self.titleLabel.textColor = [UIColor kg_blackColor];
}

- (void)setupPromtLabel {
    self.promtLabel.font = [UIFont kg_regular14Font];
    self.promtLabel.textColor = [UIColor kg_grayColor];
}

- (void)setupNextButton {
    self.nextButton.layer.cornerRadius = KGStandartCornerRadius;
    self.nextButton.backgroundColor = [UIColor kg_blueColor];
    [self.nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
    self.nextButton.titleLabel.font = [UIFont kg_regular16Font];
    self.nextButton.enabled = NO;
}

- (void)setupTextfield {

    self.textField.delegate = self;
    self.textField.textColor = [UIColor kg_blackColor];
    self.textField.font = [UIFont kg_regular16Font];
    self.textField.placeholder = @"https://matttermost.example.com";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}


#pragma mark - Configuration

- (void)configureLabels {
    self.titleLabel.text = @"Mattermost";
    self.promtLabel.text = @"Team server URL";
}

#pragma mark - Actions

- (IBAction)nextAction:(id)sender {
    [self nextActionHandler];
}

- (IBAction)textChangeAction:(id)sender {
    self.nextButton.enabled = (self.textField.text.length > 0) ? YES : NO;
}


#pragma mark - Private

- (void)setServerBaseUrl {
    [[KGPreferences sharedInstance] setServerBaseUrl:self.textField.text];
    KGLog(@"%@", [KGPreferences sharedInstance].serverBaseUrl);
}

- (void)nextActionHandler {
    if ([self.textField.text kg_isValidUrl]) {
        [self setServerBaseUrl];
        [self performSegueWithIdentifier:kShowLoginSegueIdentifier sender:nil];
    } else {
        [self processErrorWithTitle:@"Error" message:@"Incorrect server URL format"];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        [self nextActionHandler];
        
        return YES;
    }
    
    return NO;
}


@end
