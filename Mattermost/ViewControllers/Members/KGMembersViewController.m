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
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Channel.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"

@interface KGMembersViewController ()  <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>


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
    [self fillUsersArray];
//    [self setupSearchBar];
    [self setupSearchController];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setupNavigationBar {
    if (self.isAdditionMembers) {
        self.navigationItem.title = @"Add Members";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    } else {
        self.navigationItem.title = @"All Members";
    }
     self.navigationController.navigationBar.translucent = NO;
}

- (BOOL)isSearchActive {
    return self.searchController.isActive;
}

- (void)setupTable {
    self.membersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.membersTableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

//- (void)setupSearchBar {
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.translucent = NO;
//    self.searchController.delegate = self;
//    self.searchController.searchBar.scopeButtonTitles = @[];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.searchBar.tintColor = [UIColor kg_blueColor];
//    self.searchController.searchBar.backgroundColor = [UIColor kg_lightGrayColor];
//    self.searchController.searchBar.barTintColor = [UIColor kg_grayColor];
//    self.searchController.searchBar.backgroundImage = [UIImage new];
//    self.membersTableView.tableHeaderView = self.searchController.searchBar;
//}
//
//- (void)setupSearchController {
//    self.searchController.dimsBackgroundDuringPresentation = YES;
//    self.searchController.searchBar.translucent = NO;
//    self.searchController.delegate = self;
//    self.searchController.searchBar.scopeButtonTitles = @[];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.searchBar.tintColor = [UIColor kg_blueColor];
//    //    self.searchController.searchBar.backgroundColor = [UIColor kg_lightGrayColor];
//    self.searchController.searchBar.barTintColor = [UIColor kg_grayColor];
//    self.searchController.searchBar.backgroundImage = [UIImage new];
//    self.membersTableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
//}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.searchController.searchBar.delegate = self;
    self.membersTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.searchController.searchBar.barTintColor = [UIColor redColor];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.searchBar.translucent = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.obscuresBackgroundDuringPresentation = YES;
    self.searchController.delegate = self;
    self.searchController.searchBar.backgroundImage = [UIImage new];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
        KGUser *user = self.dataSource[indexPath.row];
        cell.textLabel.text = user.nickname;
    } else {
        KGUser *user = self.searchResultDataSource[indexPath.row];
       cell.textLabel.text = user.nickname;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    [[UIStatusBar sharedStatusBar] moveTemporaryToRootView];

    NSString *searchString = searchController.searchBar.text;
    if (searchString.length == 0) {
        self.searchResultDataSource = self.dataSource;
    } else {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.nickname contains[c] %@", searchString];
        self.searchResultDataSource = [self.dataSource filteredArrayUsingPredicate:resultPredicate];
    }
    [self.membersTableView reloadData];
}

- (void)fillUsersArray {
    [[KGBusinessLogic sharedInstance] loadExtraInfoForChannel:self.channel withCompletion:^(KGError *error) {
        self.dataSource = [self.channel.members allObjects];
        [self.membersTableView reloadData];
    }];
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    //self.
}

- (void)save {
    
}
@end
