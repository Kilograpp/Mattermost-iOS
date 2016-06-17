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
#import "KGAlertManager.h"

@interface KGRightMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
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

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    [self.tableView registerNib:[KGRightMenuCell nib] forCellReuseIdentifier:[KGRightMenuCell reuseIdentifier]];
}

- (void)setup {
    self.headerView.backgroundColor = [UIColor kg_leftMenuHeaderColor];
    self.nameLabel.textColor = [UIColor kg_whiteColor];
    self.nameLabel.font = [UIFont kg_boldText16Font];
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    NSLog(@"%@",user);
    //
        self.nameLabel.text = user.nickname;
    //self.avatarView.layer.cornerRadius = 17.5;
        self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
        self.avatarImageView.layer.drawsAsynchronously = YES;
        self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

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
    if (indexPath.row == 0) {
         KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
        [cell configureWithImageName:user.imageUrl];
    }
    return cell;
}

#pragma mark - Private

- (void)setupDataSource {
    NSMutableArray *rightMenuDataSource = [[NSMutableArray alloc] init];
    __weak typeof(self) wSelf = self;
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(user.nickname, nil)
                                                                     iconName:@"menu_switch_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
                                                                                                                                                    [wSelf.delegate navigationToProfil];
                                                                          
                                                                      }]];
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
#warning Сделать логаут асихнронный
        [[KGBusinessLogic sharedInstance] signOutWithCompletion:^(KGError* error) {
            if (error) {
                [[KGAlertManager sharedManager] showError:error];
            }
        }];
    KGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loadInitialScreen];
}



@end
