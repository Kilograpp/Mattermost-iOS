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
#import "KGBusinessLogic+Session.h"

static NSString *const kShowLoginSegueIdentifier = @"showLoginScreen";

@interface KGServerUrlViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promtLabel;
@property (weak, nonatomic) IBOutlet KGTextField *textField;

@property (weak, nonatomic) IBOutlet KGButton *nextButton;

@end

@implementation KGServerUrlViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupTitleLabel];
    [self setupSubtitleLabel];
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
    self.titleLabel.font = [UIFont kg_regular36Font];
    self.titleLabel.textColor = [UIColor kg_blackColor];
}

- (void)setupSubtitleLabel {
    self.subtitleLabel.font = [UIFont kg_regular14Font];
    self.subtitleLabel.textColor = [UIColor kg_loginSubtitleColor];
}

- (void)setupPromtLabel {
    self.promtLabel.font = [UIFont kg_regular14Font];
    self.promtLabel.textColor = [UIColor kg_grayColor];
}

- (void)setupNextButton {
    self.nextButton.layer.cornerRadius = KGStandartCornerRadius;
    [self.nextButton setTitle:NSLocalizedString(@"Next step", nil) forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont kg_medium18Font];
    self.nextButton.enabled = NO;
    self.nextButton.shouldDrawImageAtRightSide = YES;
}

- (void)setupTextfield {
    self.textField.delegate = self;
    self.textField.textColor = [UIColor kg_blackColor];
    self.textField.font = [UIFont kg_regular16Font];
    self.textField.placeholder = @"Your team URL";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}


#pragma mark - Configuration

- (void)configureLabels {
    self.titleLabel.text = @"Mattermost";
    self.promtLabel.text = @"e.g. https://matttermost.example.com";
    self.subtitleLabel.text = @"All your team communication in one place, searchable and accessable anywhere.";
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
    [self showProgressHud];
    [[KGBusinessLogic sharedInstance] checkUrlWithCompletion:^(KGError *error){
        if (error) {
            [self hideProgressHud];
//            //[self processError:error];
//            [self highlightTextFieldsForError];
//            [[KGAlertManager sharedManager] showError:error];
//            [self hideProgressHud];
            NSLog(@"error! %@", error.message);
        }
        else {
            NSLog(@"OK");
        }
    }];
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
