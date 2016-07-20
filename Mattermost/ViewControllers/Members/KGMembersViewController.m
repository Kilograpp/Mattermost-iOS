//
//  KGMembersViewController.m
//  Mattermost
//
//  Created by Tatiana on 19/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGMembersViewController.h"
#import "KGChannel.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NSManagedObject+CustomFinder.h"
#import "UIStatusBar+SharedBar.h"

@interface KGMembersViewController ()  <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
@property (nonatomic, strong, readwrite) NSArray *searchResultDataSource;
@property (nonatomic, strong, readwrite) NSArray *dataSource;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UISearchController *searchController;
@end

@implementation KGMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTable];
    [self setupDataSource];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchController.searchBar.backgroundColor = [UIColor lightGrayColor];

    self.membersTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"All Members";
}

- (BOOL)isSearchActive {
    return self.searchController.isActive;
}

- (void)setupTable {
    self.membersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupDataSource {
    self.dataSource = [[NSArray alloc]initWithObjects:@"Aaa",@"Bab",@"Cbb", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self isSearchActive]) {
        return self.dataSource.count;
    }
    return self.searchResultDataSource.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.imageView.image =[UIImage imageNamed:@"about_mattermost_icon"];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comments_send_icon"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (![self isSearchActive]) {
        cell.textLabel.text = self.dataSource[indexPath.row];
    } else {
        cell.textLabel.text = self.searchResultDataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [[UIStatusBar sharedStatusBar] moveTemporaryToRootView];
    NSString *searchString = searchController.searchBar.text;
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchString];
    self.searchResultDataSource = [self.dataSource filteredArrayUsingPredicate:resultPredicate];
    [self.membersTableView reloadData];
}

@end
