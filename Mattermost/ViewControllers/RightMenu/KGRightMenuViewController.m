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
#import "KGBusinessLogic+Session.h"
#import "KGAppDelegate.h"
#import "KGAlertManager.h"
#import "KGRightMenuDataSourceEntry.h"
#import "KGRightMenuCell.h"
#import "KGBusinessLogic+Session.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"
#import "KGProfileTableViewController.h"
#import "UIStatusBar+SharedBar.h"
#import "KGSideMenuContainerViewController.h"
#import "KGSettingsViewController.h"

@interface KGRightMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) NSArray *dataSource;

- (IBAction)profileAction:(id)sender;

@end


@implementation KGRightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupTableView];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //fixme abstraction
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    [self.avatarImageView setImageWithURL:user.imageUrl
                         placeholderImage:nil
                                  options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Setup

- (void)setup {
    self.headerView.backgroundColor = [UIColor kg_leftMenuHeaderColor];
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.backgroundColor = [UIColor kg_rightMenuSeparatorColor];
    [self.avatarImageView setImageWithURL:user.imageUrl
                         placeholderImage:nil
                                  options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nicknameLabel.textColor = [UIColor kg_whiteColor];
    self.nicknameLabel.font = [UIFont kg_semibold16Font];
    self.nicknameLabel.text = [@"@" stringByAppendingString:user.nickname];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    [self.tableView registerNib:[KGRightMenuCell nib] forCellReuseIdentifier:[KGRightMenuCell reuseIdentifier]];
    self.tableView.separatorColor = [UIColor kg_rightMenuSeparatorColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KGRightMenuCell heightWithObject:nil];
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
    KGRightMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:[KGRightMenuCell reuseIdentifier]];
    [cell configureWithObject:self.dataSource[indexPath.row]];
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;

    return cell;
}

#pragma mark - Private

- (void)setupDataSource {
    NSMutableArray *rightMenuDataSource = [[NSMutableArray alloc] init];
    __weak typeof(self) wSelf = self;

    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Switch Team", nil)
                                                                     iconName:@"menu_switch_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
                                                                           [wSelf alertUnderDevelopment];
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Files", nil)
                                                                     iconName:@"menu_files_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf alertUnderDevelopment];

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
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Help", nil)
                                                                     iconName:@"menu_help_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf alertUnderDevelopment];

                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Report a Problem", nil)
                                                                     iconName:@"menu_report_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf alertUnderDevelopment];

                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"About Mattermost", nil)
                                                                     iconName:@"menu_question_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          [wSelf alertUnderDevelopment];

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


#pragma mark - Private Setters
//fixme а зачем это?
- (void)setDelegate:(id<KGRightMenuDelegate>)delegate {
    _delegate = delegate;
}

#pragma mark - Navigation

- (IBAction)profileAction:(id)sender {
    [self performSegueWithIdentifier:@"presentProfile" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentProfile"]) {
        UINavigationController *nc = segue.destinationViewController;
        KGProfileTableViewController *vc = nc.viewControllers.firstObject;
        
        if (sender) {
        KGUser *user = [KGUser
                        MR_findFirstByAttribute:NSStringFromSelector(@selector(username)) withValue:sender];
            vc.userId = user.identifier;
        } else {
            vc.userId = [KGBusinessLogic sharedInstance].currentUserId;
        }
    }
}

#pragma mark - Alert

-(void) alertUnderDevelopment {
    KGAlertManager *alertView = [[KGAlertManager alloc]init];
    [alertView showWarningWithMessage:@"This section is under development"];

}





@end
