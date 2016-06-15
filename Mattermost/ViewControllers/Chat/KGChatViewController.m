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
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "KGBusinessLogic+Session.h"
#import "NSStringUtils.h"
#import "KGFollowUpChatCell.h"
#import "KGUser.h"
#import "KGImageChatCell.h"
#import "NSDate+DateFormatter.h"

#import "KGChatCommonTableViewCell.h"
#import "KGChatAttachmentsTableViewCell.h"

@import CoreText;


@interface KGChatViewController () <UINavigationControllerDelegate, KGLeftMenuDelegate, NSFetchedResultsControllerDelegate, KGRightMenuDelegate, CTAssetsPickerControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) NSMutableArray *assignedPhotos;
@property (nonatomic, strong) NSString *previousMessageAuthorId;
@property NSMutableIndexSet *deletedSections, *insertedSections;

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
    NSArray *cellClasses = @[[KGChatRootCell class], [KGFollowUpChatCell class], [KGImageChatCell class] ];
    
    for (Class class in cellClasses) {
        [self.tableView registerNib:[class nib] forCellReuseIdentifier:[class reuseIdentifier]];
    }
    
    [self.tableView registerClass:[KGChatCommonTableViewCell class] forCellReuseIdentifier:[KGChatCommonTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[KGChatAttachmentsTableViewCell class] forCellReuseIdentifier:[KGChatAttachmentsTableViewCell reuseIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupKeyboardToolbar {
    [self.rightButton setTitle:@"Отпр." forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont kg_semibold16Font];
    [self.rightButton addTarget:self action:@selector(sendPost) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(assignPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    self.textInputbar.autoHideRightButton = NO;
    self.shouldClearTextAtRightButtonPress = NO;
    self.textInputbar.textView.placeholder = @"Написать сообщение";
    self.textInputbar.textView.font = [UIFont kg_regular14Font];
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
    NSString *reuseIdentifier;
    KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    
    if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
        reuseIdentifier = post.files.count == 0 ? [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
    } else {
        KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        if ([prevPost.author.identifier isEqualToString:post.author.identifier]) {
            reuseIdentifier = post.files.count == 0 ? [KGFollowUpChatCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        } else {
            reuseIdentifier = post.files.count == 0 ? [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        }
}

    NSDate *start = [NSDate date];
    KGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDate *mid = [NSDate date];
    [cell configureWithObject:post];
    cell.transform = self.tableView.transform;
    NSDate *end = [NSDate date];
//    NSLog(@"%f - %f TOTAL : %f %d", [mid timeIntervalSinceDate:start], [end timeIntervalSinceDate:mid], [end timeIntervalSinceDate:start], post.files.count);
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    
    if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
        return post.files.count == 0 ? [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
    } else {
        KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        if ([prevPost.author.identifier isEqualToString:post.author.identifier]) {
            return post.files.count == 0 ? [KGFollowUpChatCell heightWithObject:post]  : [KGChatAttachmentsTableViewCell heightWithObject:post];;
        } else {
            return post.files.count == 0 ? [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
        }
    }
    
    return 0.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   //[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [formatter dateFromString:[sectionInfo name]];
    
    //NSString *dateName = [date dateFormatForMassage];
    NSString *dateName = [date dateFormatForMessageTitle];
    return dateName;
    //return [sectionInfo name];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor kg_blackColor]];
    [header.textLabel setFont:[UIFont kg_bold16Font]];
    header.textLabel.textAlignment = NSTextAlignmentRight;
    //    header.transform = self.tableView.transform;
    header.textLabel.transform = self.tableView.transform;
    
    header.contentView.backgroundColor = [UIColor kg_whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - NSFetchedResultsController


- (void)setupFetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel = %@", self.channel];
    self.fetchedResultsController = [KGPost MR_fetchAllSortedBy:NSStringFromSelector(@selector(createdAt))
                                                      ascending:NO
                                                  withPredicate:predicate
                                                        groupBy:NSStringFromSelector(@selector(creationDay))
                                                       delegate:self];
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
//    self.title = self.channel.displayName;
    [(KGChatNavigationController *)self.navigationController setupTitleViewWithUserName:self.channel.displayName online:arc4random() % 2];
   
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


#pragma mark - Requests

- (void)loadLastPosts {
    [[KGBusinessLogic sharedInstance] loadPostsForChannel:self.channel page:@0 size:@60 completion:^(KGError *error) {
        if (error) {
            
        }
        [self setupFetchedResultsController];
        [self.tableView reloadData];
    }];
}

- (void)sendPost {
    KGPost *post = [KGPost MR_createEntity];
    
    post.message = self.textInputbar.textView.text;
    post.author = [[KGBusinessLogic sharedInstance] currentUser];
    post.channel = self.channel;
    post.createdAt = [NSDate date];
    self.textView.text = @"";
    
    [post setBackendPendingId:[NSString stringWithFormat:@"%@:%lf",[[KGBusinessLogic sharedInstance] currentUserId], [post.createdAt timeIntervalSince1970]]];
    
    [[KGBusinessLogic sharedInstance] sendPost:post completion:^(KGError *error) {
        if (error) {
            NSLog(@"(((((((((((((((((");
        }
    
        //        [self setupFetchedResultsController];
        //        [self.tableView reloadData];
    }];
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    
    self.deletedSections = [[NSMutableIndexSet alloc] init];
    self.insertedSections = [[NSMutableIndexSet alloc] init];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
      didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
               atIndex:(NSUInteger)sectionIndex
         forChangeType:(NSFetchedResultsChangeType)type {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.deletedSections addIndexes:indexSet];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.insertedSections addIndexes:indexSet];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
       didChangeObject:(id)anObject
           atIndexPath:(NSIndexPath *)indexPath
         forChangeType:(NSFetchedResultsChangeType)type
          newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            // iOS 9.0b5 sends the same index path twice instead of delete
            if(![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if([self.insertedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: Moving first item from section 0 (which becomes section 1 later) to section 0
                // Really the only way is to delete and insert the same index path...
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if([self.deletedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: same index path reported after section was removed
                // we can ignore item deletion here because the whole section was removed anyway
                [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            // On iOS 9.0b5 NSFetchedResultsController may not even contain such indexPath anymore
            // when removing last item from section.
            if(![self.deletedSections containsIndex:indexPath.section] && ![self.insertedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 sends update before delete therefore we cannot use reload
                // this will never work correctly but at least no crash.
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [self configureCell:(KGTableViewCell *)cell atIndexPath:indexPath];
            }
            
            break;
    }
}

#pragma mark - Private

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell configureWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    cell.transform = self.tableView.transform;
}

- (void)assignPhotos {
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            // init picker
//            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
//            
//            // set delegate
//            picker.delegate = self;
//            
//            // Optionally present picker as a form sheet on iPad
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//                picker.modalPresentationStyle = UIModalPresentationFormSheet;
//            
//            // present picker
//            [self presentViewController:picker animated:YES completion:nil];
//        });
//    }];
//    [self.textInputbar attachFile:[UIImage imageNamed:@"icn_upload"]];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    PHImageManager *manager = [PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    __block UIImage *img;
    __weak typeof(self) wSelf = self;
    
    for (PHAsset *asset in assets) {
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeAspectFill
                              options:self.requestOptions
                        resultHandler:^(UIImage *image, NSDictionary *info) {
                            img = image;
                            [wSelf.assignedPhotos addObject:img];
                        }];
    }
}

@end
