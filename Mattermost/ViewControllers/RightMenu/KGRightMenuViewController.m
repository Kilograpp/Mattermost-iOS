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
#import "KGRightMenuDataSourceEntry.h"
#import "KGRightMenuCell.h"
#import "KGBusinessLogic+Session.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

@interface KGRightMenuViewController () <UITableViewDelegate, UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) NSArray *dataSource;
@end


@implementation KGRightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupTableView];
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    self.headerView.backgroundColor = [UIColor kg_leftMenuHeaderColor];
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.backgroundColor = [UIColor kg_rightMenuSeparatorColor];
    [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nicknameLabel.textColor = [UIColor kg_whiteColor];
    self.nicknameLabel.font = [UIFont kg_semibold16Font];
    self.nicknameLabel.text = [@"@" stringByAppendingString:user.nickname];
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    [self.tableView registerNib:[KGRightMenuCell nib] forCellReuseIdentifier:[KGRightMenuCell reuseIdentifier]];
    self.tableView.separatorColor = [UIColor kg_rightMenuSeparatorColor];
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
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
//    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(user.nickname, nil)
//                                                                     iconName:@"menu_switch_icon"
//                                                                   titleColor:[UIColor kg_whiteColor]
//                                                                      handler:^{
//                                                                        [wSelf.delegate navigationToProfil];
//                                                                          
//                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Switch Team", nil)
                                                                     iconName:@"menu_switch_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
//                                                                           [wSelf.delegate navigationToProfil];
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Files", nil)
                                                                     iconName:@"menu_files_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          // [wSelf performSegueWithIdentifier:kAccountSettingsIdentifier sender:nil];
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Settings", nil)
                                                                     iconName:@"menu_settings_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          //[wSelf navigateToNewMember];
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Invite New Members", nil)
                                                                     iconName:@"menu_invite_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                   
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Help", nil)
                                                                     iconName:@"menu_help_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Report a Problem", nil)
                                                                     iconName:@"menu_report_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"About Mattermost", nil)
                                                                     iconName:@"menu_question_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Logout", nil)
                                                                     iconName:@"menu_logout_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
                                                                          [wSelf logout];
                                                                      }]];
    
    
    
    self.dataSource = rightMenuDataSource.copy;

}


#pragma mark - Actions

- (void)toggleRightSideMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

#pragma mark - Private Setters

- (void)setDelegate:(id<KGRightMenuDelegate>)delegate {
    _delegate = delegate;
}

#pragma mark - Navigation

- (void)logout {
    [[KGBusinessLogic sharedInstance] signOutWithCompletion:^(KGError* error) {
        KGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate loadInitialScreen];
    }];

}



@end
