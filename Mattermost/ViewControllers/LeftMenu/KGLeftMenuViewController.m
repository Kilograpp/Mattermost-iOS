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

@interface KGLeftMenuViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
- (IBAction)signOutAction:(id)sender;

@end

@implementation KGLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadChannels];
    [self setup];
    [self setupAvatarImageView];
    [self setupNicknameLabel];
    [self setupTeamLabel];
    [self configureHeaderView];
}


#pragma mark - Setup

- (void)setup {
    self.view.backgroundColor = [UIColor kg_blueColor];
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
    return 3;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
//
//}

#pragma mark - Requests

- (void)loadChannels {
    [self showProgressHud];
    
    self.fetchedResultsController = [KGChannel MR_fetchAllSortedBy:nil ascending:NO withPredicate:nil groupBy:nil delegate:self];
}

@end
