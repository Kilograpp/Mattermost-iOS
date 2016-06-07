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

@interface KGServerUrlViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promtLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation KGServerUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTitleLabel];
    [self setupSubtitleLabel];
    [self setupPromtLabel];
    [self setupNextButton];
}

#pragma mark - Setup 

- (void)setupTitleLabel {
    self.titleLabel.font = [UIFont kg_semibold30Font];
}

- (void)setupSubtitleLabel {
    self.subtitleLabel.font = [UIFont kg_light18Font];
}

- (void)setupPromtLabel {
    self.promtLabel.font = [UIFont kg_regular14Font];
}

- (void)setupNextButton {
    self.nextButton.layer.cornerRadius = 2.f;
    self.nextButton.backgroundColor = [UIColor kg_blueColor];
    [self.nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
}
#pragma mark - Actions

- (IBAction)nextAction:(id)sender {
}


@end
