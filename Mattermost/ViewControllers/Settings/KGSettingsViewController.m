//
//  KGSettingsViewController.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGSettingsViewController.h"
#import "KGPreferences.h"
#import "UIFont+KGPreparedFont.h"

@interface KGSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
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

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.font = [UIFont kg_regular13Font];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont kg_regular14Font];
}

@end
