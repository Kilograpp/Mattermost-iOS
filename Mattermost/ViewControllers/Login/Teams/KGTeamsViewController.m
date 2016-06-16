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

@interface KGTeamsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KGTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    [self setup];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSNumber *index = self.numberOfPhoto[indexPath.row];
    return 60.f;
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
