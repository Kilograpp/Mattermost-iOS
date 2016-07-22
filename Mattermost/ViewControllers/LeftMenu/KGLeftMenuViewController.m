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
#import "KGBusinessLogic+Channel.h"
#import "KGAppDelegate.h"
#import "KGChannel.h"
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannelTableViewCell.h"
#import "KGUtils.h"
#import "NSManagedObject+CustomFinder.h"
#import <mach/mach.h>
#import <MFSideMenu/MFSideMenu.h>
#import "KGNotificationValues.h"
#import "KGPreferences.h"
#import "KGChannelsObserver.h"
#import "KGHardwareUtils.h"
#import "KGConstants.h"

@interface KGLeftMenuViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *allUsersCommandButton;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation KGLeftMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupTableView];
    [self setupTeamLabel];
    [self configureHeaderView];
    [self setupFetchedResultsController];
    [self registerObservers];
    [self setInitialSelectedChannel];
}


#pragma mark - Setup

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[KGChannelTableViewCell nib]
         forCellReuseIdentifier:[KGChannelTableViewCell reuseIdentifier]];
}

- (void)setup {
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.headerView.backgroundColor = [UIColor kg_leftMenuHeaderColor];
}


- (void)setupTeamLabel {
    self.teamLabel.textColor = [UIColor kg_whiteColor];
    self.teamLabel.font = [UIFont kg_boldText16Font];
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
    KGChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGChannelTableViewCell reuseIdentifier]];
    KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    BOOL shouldHighlight = indexPath.row == _selectedIndexPath.row && indexPath.section == _selectedIndexPath.section;
    cell.isSelectedCell = shouldHighlight;
    [cell configureWithObject:channel];
    
    return cell;
}


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
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 30, 0 , tableView.sectionHeaderHeight, tableView.sectionHeaderHeight)];
   [ button setImage:[UIImage imageNamed:@"menu_add_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addChannelAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
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

- (void)moreAction {
    [[KGAlertManager sharedManager] showWarningWithMessage:@"This section is under development"];
}
- (void)addChannelAction {
        [[KGAlertManager sharedManager] showWarningWithMessage:@"This section is under development"];
}

- (void)selectChannelAtIntexPath:(NSIndexPath *)indexPath {
    KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[KGChannelsObserver sharedObserver] setSelectedChannel:channel];
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
}

- (void)reselectCurrentIndexPath {
    [self selectChannelAtIntexPath:self.selectedIndexPath];
}

- (void)selectChannel:(KGChannel*)channel {
    NSIndexPath* path = [self.fetchedResultsController indexPathForObject:channel];
    self.selectedIndexPath = path;
    [self.tableView reloadData];
}

- (void)setInitialSelectedChannel {
    NSIndexPath *path;
    
    if (![[KGPreferences sharedInstance] lastChannelId]) {
        //первый вход
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        //последний сохраненный канал
        NSString *channelId = [[KGPreferences sharedInstance] lastChannelId];
        KGChannel *channel = [KGChannel managedObjectById:channelId];
        path = [self.fetchedResultsController indexPathForObject:channel];
    }
    
    [self selectChannelAtIntexPath:path];
}

- (void)updateTableView:(NSNotification *)notification {
    if ([[KGHardwareUtils sharedInstance] devicePerformance] == KGPerformanceHigh ||
        [[KGHardwareUtils sharedInstance] currentCpuLoad] < 30) {
        [self.tableView reloadData];
    }
}


#pragma mark - Actions

- (void)toggleLeftSideMenuAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


#pragma mark - Notifications

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:KGNotificationUsersStatusUpdate
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:KGNotificationChannelsStateUpdate
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:KGNotificationDidReceiveNewMessage
                                               object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeObserver];
}


@end
