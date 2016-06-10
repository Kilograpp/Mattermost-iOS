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


@interface KGChatViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KGChatViewController

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[KGBusinessLogic sharedInstance] loadPostsForChannel:[KGChannel MR_findFirst] page:@0 size:@60 completion:^(KGError *error) {
        [self.tableView reloadData];
    }];
    [self setupTableView];

}

- (void)setupTableView {


    [self.tableView registerNib:[KGChatRootCell nib] forCellReuseIdentifier:[KGChatRootCell reuseIdentifier]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupFetchedResultsController];
    [self.tableView reloadData];
}


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


    self.fetchedResultsController = [KGPost MR_fetchAllSortedBy:nil
                                                      ascending:YES
                                                  withPredicate:nil
                                                        groupBy:nil
                                                       delegate:nil];
}


@end
