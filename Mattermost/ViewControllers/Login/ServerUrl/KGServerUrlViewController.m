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
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface KGServerUrlViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promtLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
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
}

- (void)setupTextfield {
    self.textField.textColor = [UIColor kg_blackColor];
    self.textField.font = [UIFont kg_regular16Font];
    self.textField.placeholder = @"https://matttermost.example.com";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}


#pragma mark - Configuration

- (void)configureLabels {
    self.titleLabel.text = @"Mattermost";
    self.subtitleLabel.text = @"All your team communication in one place, searchable and accessable anywhere";
    self.promtLabel.text = @"Team server URL";
}

#pragma mark - Actions

- (IBAction)nextAction:(id)sender {
}


@end
