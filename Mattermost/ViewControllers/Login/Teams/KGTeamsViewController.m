//
//  KGTeamsViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTeamsViewController.h"
#import "KGTeamCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "CAGradientLayer+KGPreparedGradient.h"

@interface KGTeamsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

@implementation KGTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    [self setup];
    [self setupNavigationBar];
}


#pragma mark - Setup

- (void)setupTable {
     [self.tableView registerNib:[KGTeamCell nib] forCellReuseIdentifier:[KGTeamCell reuseIdentifier]];
}

- (void)setup {
    self.titleLabel.text = @"Kilograpp";
    self.title = @"Choose your team";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont kg_bold28Font];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)setupNavigationBar{
    CAGradientLayer *bgLayer = [CAGradientLayer kg_blueGradientForNavigationBar];
    bgLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 2.88);
    [bgLayer animateLayerInfinitely:bgLayer];
    [self.navigationView.layer insertSublayer:bgLayer above:0];
    [self.navigationView bringSubviewToFront:self.titleLabel];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KGTeamCell heightWithObject:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGTeamCell reuseIdentifier]];
    [cell configureWithObject:nil];
   
    return cell;
}
@end
