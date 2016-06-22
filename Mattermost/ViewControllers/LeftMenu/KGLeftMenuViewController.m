//
//  KGLeftMenuViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGLeftMenuViewController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGTeam.h"
#import "KGUser.h"
#import "KGBusinessLogic+Team.h"
#import "KGBusinessLogic+Session.h"
#import "KGAppDelegate.h"
#import "KGChannel.h"
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannelTableViewCell.h"
#import "KGUtils.h"
#import "NSManagedObject+CustomFinder.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <MFSideMenu/MFSideMenu.h>
#import "KGNotificationValues.h"

@interface KGLeftMenuViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *allUsersCommandButton;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation KGLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[KGBusinessLogic sharedInstance] updateStatusForUsers:[KGUser MR_findAll]  completion:nil];
    [self setup];
    [self setupTableView];
    [self setupTeamLabel];
    [self configureHeaderView];
    [self setupFetchedResultsController];
    [self registerObservers];
}


#pragma mark - Setup

//-  (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[KGChannelTableViewCell nib] forCellReuseIdentifier:[KGChannelTableViewCell reuseIdentifier]];
}

- (void)setup {
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.headerView.backgroundColor = [UIColor kg_leftMenuHeaderColor];
}


- (void)setupTeamLabel {
    self.teamLabel.textColor = [UIColor kg_whiteColor];
    self.teamLabel.font = [UIFont kg_boldText16Font];
}

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:KGNotificationUsersStatusUpdate object:nil];
}

- (void)updateTableView:(NSNotification *)notification {

        NSIndexPath *selectedIndexPath  = [self.tableView indexPathForSelectedRow];
       [self.tableView reloadData];
       [self.tableView beginUpdates];
       [self.tableView endUpdates];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO
                              scrollPosition:UITableViewScrollPositionNone];

}


#pragma mark - Configuration

- (void)configureHeaderView {
    KGTeam *team = [[KGBusinessLogic sharedInstance] currentTeam];
    self.teamLabel.text = team.displayName;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGChannelTableViewCell reuseIdentifier] ];
    KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
 //   cell.isSelectedCell = (indexPath.row == self.selectedRow) ? YES : NO;
    [cell configureWithObject:channel];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateTableView:nil];//4
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//   [self updateTableView:nil]; //1
//}
//
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self updateTableView:nil];//2
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    [self updateTableView:nil];
//    //3
//}




#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSString *sectionHeaderTitle = [[KGChannel titleForChannelBackendType:[sectionInfo name]] uppercaseString];
    
    return sectionHeaderTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KGChannelTableViewCell heightWithObject:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor kg_sectionColorLeftMenu]];
    [header.textLabel setFont:[UIFont kg_boldText10Font]];
    header.contentView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectChannelAtIntexPath:indexPath];
    [self toggleLeftSideMenuAction];
}

#pragma mark - NSFetchedResultsController

- (void)setupFetchedResultsController {
    NSSortDescriptor *backendTypeSort = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(backendType))
                                                                      ascending:NO];
    NSSortDescriptor *displayNameSort = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(displayName))
                                                                      ascending:YES
                                                                       selector:@selector(caseInsensitiveCompare:)];

    NSFetchRequest *fetchRequest = [KGChannel MR_requestAll];
    [fetchRequest setFetchLimit:100];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:@[backendTypeSort, displayNameSort]];

    self.fetchedResultsController = [KGChannel MR_fetchController:fetchRequest
                                                         delegate:nil
                                                        groupedBy:NSStringFromSelector(@selector(backendType))];

}


#pragma mark - Private

- (void)selectChannelAtIntexPath:(NSIndexPath *)indexPath {
    KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate didSelectChannelWithIdentifier:channel.identifier];
    self.selectedRow = indexPath.row;
    
}

- (void)setInitialSelectedChannel {
    NSIndexPath *firstChannelPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:firstChannelPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self selectChannelAtIntexPath:firstChannelPath];
}

#pragma mark - Actions

- (void)toggleLeftSideMenuAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


#pragma mark - Private Setters

- (void)setDelegate:(id<KGLeftMenuDelegate>)delegate {
    _delegate = delegate;
    [self setInitialSelectedChannel];
}

@end
