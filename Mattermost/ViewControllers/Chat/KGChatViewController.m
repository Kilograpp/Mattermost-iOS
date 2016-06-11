//
//  KGChatViewController.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController.h"
#import "KGChatRootCell.h"
#import "KGPost.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Posts.h"
#import "KGChannel.h"
#import <MagicalRecord.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGChatNavigationController.h"
#import <MFSideMenu/MFSideMenu.h>
#import "KGLeftMenuViewController.h"
#import "KGBusinessLogic+Socket.h"
#import "KGBusinessLogic+Channel.h"
#import "KGRightMenuViewController.h"
#import "KGPresentNavigationController.h"
#import <Masonry/Masonry.h>
#import "KGConstants.h"



@interface KGChatViewController () <UINavigationControllerDelegate, KGLeftMenuDelegate, KGRightMenuDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@end

@implementation KGChatViewController

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupTableView];
    [self setupKeyboardToolbar];
    [self setupLeftBarButtonItem];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        self.navigationController.delegate = nil;
    }


}


#pragma mark - Setup

- (void)setup {
    self.navigationController.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    KGLeftMenuViewController *leftVC = (KGLeftMenuViewController *)self.menuContainerViewController.leftMenuViewController;
    KGRightMenuViewController *rightVC  = (KGRightMenuViewController *)self.menuContainerViewController.rightMenuViewController;
    leftVC.delegate = self;
    rightVC.delegate = self;

}

- (void)setupTableView {
    [self.tableView registerNib:[KGChatRootCell nib] forCellReuseIdentifier:[KGChatRootCell reuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)setupKeyboardToolbar {
    [self.rightButton setTitle:@"Отпр." forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont kg_semibold16Font];

    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.textView.placeholder = @"Написать сообщение";
    self.textInputbar.textView.font = [UIFont kg_regular15Font];
}

- (void)setupLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(toggleLeftSideMenuAction)];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGChatRootCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGChatRootCell reuseIdentifier] forIndexPath:indexPath];

    [cell configureWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    cell.transform = self.tableView.transform;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KGChatRootCell heightWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}


- (void)setupFetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel = %@", self.channel];
    self.fetchedResultsController = [KGPost MR_fetchAllSortedBy:NSStringFromSelector(@selector(createdAt))
                                                      ascending:NO
                                                  withPredicate:predicate
                                                        groupBy:nil
                                                       delegate:nil];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[KGChatNavigationController class]]) {
        if (navigationController.viewControllers.count == 1) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(toggleLeftSideMenuAction)];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(toggleRightSideMenuAction)];
        }
        
    }
}


#pragma mark - KGLeftMenuDelegate

- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier {
    [self showLoadingView];
    self.channel = [KGChannel managedObjectById:idetnfifier];
   
    [[KGBusinessLogic sharedInstance] loadExtraInfoForChannel:self.channel withCompletion:^(KGError *error) {
        [[KGBusinessLogic sharedInstance] loadPostsForChannel:self.channel page:@0 size:@60 completion:^(KGError *error) {
            if (error) {
                [self hideLoadingViewAnimated:YES];
            }
            [self setupFetchedResultsController];
            [self.tableView reloadData];
            [self hideLoadingViewAnimated:YES];
            
        }];
    }];
}

#pragma mark = KGRightMenuDelegate

-(void)navigationToProfil {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingsAccount" bundle:nil];
    KGPresentNavigationController *presentNC = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    presentNC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:presentNC animated:YES completion:nil];
    });
    
}


#pragma mark - Actions

- (void)toggleLeftSideMenuAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)toggleRightSideMenuAction {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

#pragma mark - Loading View

- (UIActivityIndicatorView *)loadingActivityIndicator {
    if (!_loadingActivityIndicator) {
        _loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingActivityIndicator.hidesWhenStopped = YES;
    }
    
    return _loadingActivityIndicator;
}

- (void)showLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.loadingView addSubview:self.loadingActivityIndicator];
    [self.loadingActivityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingView);
    }];
    [self.loadingActivityIndicator startAnimating];
}

- (void)hideLoadingViewAnimated:(BOOL)animated {
    CGFloat duration = animated ? KGStandartAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingActivityIndicator stopAnimating];
        [self.loadingView removeFromSuperview];
    }];
}

@end
