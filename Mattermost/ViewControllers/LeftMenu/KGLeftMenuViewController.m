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
#import "KGBusinessLogic+Session.h"
#import "KGAppDelegate.h"
#import "KGChannel.h"
#import <MagicalRecord/MagicalRecord.h>
#import "KGChannelTableViewCell.h"
#import "KGUtils.h"
#import "NSManagedObject+CustomFinder.h"

@interface KGLeftMenuViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
- (IBAction)signOutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KGLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.tableView registerNib:[KGChannelTableViewCell nib] forCellReuseIdentifier:[KGChannelTableViewCell reuseIdentifier]];
    self.tableView.delegate = self;
    [self setup];
    [self setupAvatarImageView];
    [self setupNicknameLabel];
    [self setupTeamLabel];
    [self configureHeaderView];
    [self setupFetchedResultsController];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


#pragma mark - Setup

- (void)setup {
    self.view.backgroundColor = [UIColor kg_blueColor] ;
    //self.tableView.backgroundColor = [UIColor kg_blueColor];
}

- (void)setupAvatarImageView {
    self.avatarImageView.layer.cornerRadius = 30.f;
}

- (void)setupNicknameLabel {
    self.nicknameLabel.textColor = [UIColor kg_whiteColor];
    self.nicknameLabel.font = [UIFont kg_regular16Font];
}

- (void)setupTeamLabel {
    self.teamLabel.textColor = [UIColor kg_whiteColor];
    self.teamLabel.font = [UIFont kg_semibold20Font];
}


#pragma mark - Configuration

- (void)configureHeaderView {
    KGTeam *team = [[KGBusinessLogic sharedInstance] currentTeam];
    self.teamLabel.text = team.displayName;
    
    KGUser *currentUser = [[KGBusinessLogic sharedInstance] currentUser];
    self.nicknameLabel.text = [@"@" stringByAppendingString:currentUser.username];
}

- (IBAction)signOutAction:(id)sender {
    [[KGBusinessLogic sharedInstance] signOut];
    KGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loadInitialScreen];
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
    [cell configureWithObject:channel];
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSString *sectionHeaderTitle = [[KGChannel titleForChannelBackendType:[sectionInfo name]] uppercaseString];
    
    return sectionHeaderTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor kg_whiteColor]];
    [header.textLabel setFont:[UIFont kg_regular18Font]];
    
    header.contentView.backgroundColor = [[UIColor kg_blueColor] colorWithAlphaComponent:0.8];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return tableView.sectionFooterHeight;
    return 40.f;
}

#pragma mark - NSFetchedResultsController

- (void)setupFetchedResultsController {

    NSSortDescriptor *backendTypeSort = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(backendType))
                                                                      ascending:NO ];
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

@end
