//
//  KGTeamsViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTeamsViewController.h"
#import "KGTeamCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "CAGradientLayer+KGPreparedGradient.h"
#import "KGBusinessLogic+Team.h"
#import "KGTeam.h"
#import "KGObjectManager.h"
#import <MagicalRecord/MagicalRecord/NSManagedObject+MagicalFinders.h>
//#import "KGBusinessLogic+Session.h"
#import "KGBusinessLogic+Channel.h"
#import "KGSideMenuContainerViewController.h"
#import "KGPreferences.h"
@interface KGTeamsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation KGTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    [self setup];
    [self setupNavigationBar];
    [self setupFetchedResultsController];
    [self.tableView reloadData];
}


#pragma mark - Setup

- (void)setupTable {
     [self.tableView registerNib:[KGTeamCell nib] forCellReuseIdentifier:[KGTeamCell reuseIdentifier]];
}

- (void)setup {
    NSString *siteName = [[KGPreferences sharedInstance] siteName];
    self.titleLabel.text = siteName;
    self.title = @"Choose your team";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont kg_bold28Font];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)setupNavigationBar{
    CAGradientLayer *bgLayer = [CAGradientLayer kg_blueGradientForNavigationBar];
    bgLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 2.88);
    [bgLayer animateLayerInfinitely:bgLayer];
    [self.navigationView.layer insertSublayer:bgLayer above:0];
    [self.navigationView bringSubviewToFront:self.titleLabel];
}

+ (instancetype)configuredContainerViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    NSString *str = NSStringFromClass([KGTeamsViewController class]);
    KGTeamsViewController *vc = [sb instantiateViewControllerWithIdentifier:str];
    return vc;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KGTeamCell heightWithObject:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGTeamCell reuseIdentifier]];
    KGTeam *team = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithObject:team];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showProgressHud];
    [[KGBusinessLogic sharedInstance] loadChannelsWithCompletion:^(KGError *error) {
        [self hideProgressHud];
        if (error) {
            [[KGAlertManager sharedManager] showError:error];
            [self hideProgressHud];
        } else {
            KGSideMenuContainerViewController *vc = [KGSideMenuContainerViewController configuredContainerViewController];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    

}

#pragma mark - NSFetchedResultsController

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [KGTeam MR_fetchAllSortedBy:nil ascending:NO withPredicate:nil groupBy:nil delegate:self];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
