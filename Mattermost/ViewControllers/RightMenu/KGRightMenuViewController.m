//
//  RightMenu.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGRightMenuViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MFSideMenu/MFSideMenu.h>
#import <Masonry/Masonry.h>
#import "KGBusinessLogic+Session.h"
#import "KGUser.h"
#import "KGAppDelegate.h"
#import "KGAlertManager.h"
#import "KGBusinessLogic+Session.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"
#import "KGProfileTableViewController.h"
#import "UIStatusBar+SharedBar.h"
#import "KGSideMenuContainerViewController.h"
#import "KGSettingsViewController.h"
#import "KGTeamsViewController.h"
#import "KGAboutMattermostViewController.h"
#import "KGLoginNavigationController.h"
#import <UITableView_Cache/UITableView+Cache.h>
#import "KGConstants.h"

#import "KGRightMenuDataSourceEntry.h"
#import "KGManualRightMenuCell.h"
#import "KGHeaderRightMenuCell.h"

#define KG_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
const static CGFloat KGHeightHeader = 64;

@interface KGRightMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) KGHeaderRightMenuCell *headerView;
@end


@implementation KGRightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDataSource];
    [self setupHeader];
    [self setupTableView];
}

#pragma mark - Setup

- (void)setupHeader {
    self.headerView = [[KGHeaderRightMenuCell alloc]initWithFrame:CGRectMake(0, 0, KG_SCREEN_WIDTH, KGHeightHeader)];
    KGUser *user = [[KGBusinessLogic sharedInstance] currentUser];
    [self.headerView configureWithObject:user];
    __weak __typeof(self)wself = self;
    self.headerView.handler = ^(){
        [wself.delegate navigationToProfile];
    };
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
}

- (void)setupTableView {
    [self.tableView registerClass:[KGManualRightMenuCell class]
           forCellReuseIdentifier:[KGManualRightMenuCell reuseIdentifier] cacheSize:5];
    
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [[UIColor kg_rightMenuSeparatorColor] colorWithAlphaComponent:0.7];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KGManualRightMenuCell heightCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KGRightMenuDataSourceEntry *item = self.dataSource[indexPath.row];
    item.handler();
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KGManualRightMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGManualRightMenuCell reuseIdentifier]];
    [cell configureWithObject:self.dataSource[indexPath.row]];

    return cell;
}

#pragma mark - Private

- (void)setupDataSource {
    NSMutableArray *rightMenuDataSource = [[NSMutableArray alloc] init];
    __weak typeof(self) wSelf = self;

    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Switch Team", nil)
                                                                     iconName:@"menu_switch_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf navigateToTeams];
                                                                          
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Settings", nil)
                                                                     iconName:@"menu_settings_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf navigateToSettings];
                                                                         
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Invite New Members", nil)
                                                                     iconName:@"menu_invite_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf alertUnderDevelopment];
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"About Mattermost", nil)
                                                                     iconName:@"menu_question_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf navigateToAbout];
                                                                         
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Logout", nil)
                                                                     iconName:@"menu_logout_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
                                                                          [wSelf logout];
                                                                          
                                                                      }]];
    
    
    
    self.dataSource = rightMenuDataSource.copy;

}

- (void)navigateToSettings {
    UINavigationController *nc = self.menuContainerViewController.centerViewController;
    if (![nc.topViewController isKindOfClass:[KGSettingsViewController class]]) {
        [self toggleRightSideMenuAction];
        [self.delegate navigateToSettings];
    }
}

- (void)navigateToAbout {
    UINavigationController *nc = self.menuContainerViewController.centerViewController;
    if (![nc.topViewController isKindOfClass:[KGAboutMattermostViewController class]]) {
        [self toggleRightSideMenuAction];
        [self.delegate navigateToAboutMattermost];
    }
}

- (void)navigateToTeams {
    KGLoginNavigationController *nc = self.menuContainerViewController.centerViewController;
    if (![nc.topViewController isKindOfClass:[KGTeamsViewController class]]) {
        [self toggleRightSideMenuAction];
        [self.delegate navigateToTeams];
        [[UIStatusBar sharedStatusBar] restoreState];
    }
}

#pragma mark - Actions

- (void)toggleRightSideMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)logout {
    [[KGAlertManager sharedManager] showProgressHud];
    [[KGBusinessLogic sharedInstance] signOutWithCompletion:^(KGError* error) {
        [[KGAlertManager sharedManager] hideHud];
        KGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[KGAlertManager sharedManager] hideHud];
        [appDelegate loadInitialScreen];
        [[UIStatusBar sharedStatusBar] restoreState];
    }];
    
}
/*
- (void)showTeams {
    KGTeamsViewController *vc = [KGTeamsViewController configuredContainerViewController];
    [self presentViewController:vc animated:YES completion:nil];
    [[UIStatusBar sharedStatusBar] restoreState];
}
*/

#pragma mark - Alert

-(void) alertUnderDevelopment {
    [[KGAlertManager sharedManager] showWarningWithMessage:@"This section is under development"];
}


#pragma mark - Public

- (void)updateAvatarImage {
    KGUser *user = [[KGBusinessLogic sharedInstance] currentUser];
    [self.headerView configureWithObject:user];
}


@end
