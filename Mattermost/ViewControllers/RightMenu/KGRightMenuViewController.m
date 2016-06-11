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

#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"

@interface KGRightMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end


@implementation KGRightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupTableView];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    self.view.backgroundColor = [UIColor kg_leftMenuBackgroundColor];
    [self.tableView registerNib:[KGRightMenuCell nib] forCellReuseIdentifier:[KGRightMenuCell reuseIdentifier]];
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
    return cell;
}

#pragma mark - Private

- (void)setupDataSource {
    NSMutableArray *rightMenuDataSource = [[NSMutableArray alloc] init];
    __weak typeof(self) wSelf = self;
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Profile", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_whiteColor]
                                                                      handler:^{
                                                                           [wSelf.delegate navigationToProfil];
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Settings", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          // [wSelf performSegueWithIdentifier:kAccountSettingsIdentifier sender:nil];
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Invite New Member", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          //[wSelf navigateToNewMember];
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Switch Team", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                   
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Help", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Report a Problem", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"About Mattermost", nil)
                                                                     iconName:@"navbar_close_icon"
                                                                   titleColor:[UIColor kg_lightBlueColor]
                                                                      handler:^{
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGRightMenuDataSourceEntry entryWithTitle:NSLocalizedString(@"Logout", nil)
                                                                     iconName:@"navbar_close_icon"
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
    [[KGBusinessLogic sharedInstance] signOut];
    KGAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loadInitialScreen];
}



@end
