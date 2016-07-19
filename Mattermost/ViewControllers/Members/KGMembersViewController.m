//
//  KGMembersViewController.m
//  Mattermost
//
//  Created by Tatiana on 19/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGMembersViewController.h"

@interface KGMembersViewController ()  <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation KGMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTextField];
    [self setupTable];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"All Members";
}

- (void)setupTable {
    
}

- (void)setupTextField {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   cell.textLabel.text = @"User";
    cell.imageView.image =[UIImage imageNamed:@"about_mattermost_icon"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

@end
