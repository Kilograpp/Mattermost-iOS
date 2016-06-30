//
//  KGSettingsViewController.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGSettingsViewController.h"
#import "KGPreferences.h"

@interface KGSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *compressImagesSwitch;
@end

@implementation KGSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureSwitch];
}

#pragma mark - Actions

- (IBAction)shouldCompressValueChanged:(id)sender {
    [self toggleShouldCompressValue];
}


#pragma mark - Private

- (void)configureSwitch {
    [self.compressImagesSwitch setOn:[KGPreferences sharedInstance].shouldCompressImages];
}

- (void)toggleShouldCompressValue {
    [KGPreferences sharedInstance].shouldCompressImages = self.compressImagesSwitch.isOn;
    [[KGPreferences sharedInstance] save];
}

@end
