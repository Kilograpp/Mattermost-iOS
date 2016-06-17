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
#import "KGBusinessLogic+File.h"
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
#import "KGChannelNotification.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGFile.h"
#import "KGAlertManager.h"

@interface KGChatViewController () <UINavigationControllerDelegate, KGLeftMenuDelegate, NSFetchedResultsControllerDelegate, KGRightMenuDelegate, CTAssetsPickerControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) NSMutableArray *assignedPhotos;
@property (nonatomic, strong) NSMutableArray* chatRootCells;
@property (nonatomic, strong) NSMutableArray* followupCells;
@property (nonatomic, strong) NSMutableArray* imageCells;
@property (nonatomic, strong) NSString *previousMessageAuthorId;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) KGPost *currentPost;
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
    [self setupRefreshControl];
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
//    NSArray *cellClasses = @[[KGChatRootCell class], [KGFollowUpChatCell class], [KGImageChatCell class] ];

//    for (Class class in cellClasses) {
//        [self.tableView registerNib:[class nib] forCellReuseIdentifier:[class reuseIdentifier]];
//    }

    _chatRootCells = [NSMutableArray arrayWithCapacity:15];
    _imageCells = [NSMutableArray arrayWithCapacity:15];
    _followupCells = [NSMutableArray arrayWithCapacity:15];


    for (int i = 0; i < 15; i++) {
        
        UITableViewCell* cell = [[KGChatCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KGChatCommonTableViewCell reuseIdentifier]];
        [_chatRootCells addObject:cell];
        
        cell = [[KGChatAttachmentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[KGChatAttachmentsTableViewCell reuseIdentifier]];
        [_imageCells addObject:cell];
    
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KGFollowUpChatCell" owner:self options:nil] firstObject];
        [_followupCells addObject:cell];
    }

    //[self.tableView registerClass:[KGChatCommonTableViewCell class] forCellReuseIdentifier:[KGChatCommonTableViewCell reuseIdentifier]];
    //[self.tableView registerClass:[KGChatAttachmentsTableViewCell class] forCellReuseIdentifier:[KGChatAttachmentsTableViewCell reuseIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupKeyboardToolbar {
    [self.rightButton setTitle:@"Send" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont kg_semibold16Font];
    [self.rightButton addTarget:self action:@selector(sendPost) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(assignPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    self.textInputbar.autoHideRightButton = NO;
    self.shouldClearTextAtRightButtonPress = NO;
    self.textInputbar.textView.font = [UIFont kg_regular15Font];
    self.textInputbar.textView.placeholder = @"Type something...";
    self.textInputbar.textView.layer.borderWidth = 0.f;
    self.textInputbar.translucent = NO;
    self.textInputbar.barTintColor = [UIColor kg_whiteColor];
}

- (void)setupLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(toggleLeftSideMenuAction)];
}

#pragma mark - RefreshControl
-(void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
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
    KGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        if ([[KGChatCommonTableViewCell reuseIdentifier] isEqualToString:reuseIdentifier]) {
            cell = _chatRootCells.firstObject;
        
            [_chatRootCells removeObject:cell];
        }
        if ([[KGChatAttachmentsTableViewCell reuseIdentifier] isEqualToString:reuseIdentifier]) {
            cell = _imageCells.firstObject;
            [_imageCells removeObject:cell];
        }
        if ([[KGFollowUpChatCell reuseIdentifier] isEqualToString:reuseIdentifier]) {
            cell = _followupCells.firstObject;
            [_followupCells removeObject:cell];
        }
    } else {
        NSLog(@"Quequed");
    }
    
    if (!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    NSDate *mid = [NSDate date];
    [cell configureWithObject:post];
    cell.transform = self.tableView.transform;
    NSDate *end = [NSDate date];
    NSLog(@"%f - %f TOTAL : %f %d", [mid timeIntervalSinceDate:start], [end timeIntervalSinceDate:mid], [end timeIntervalSinceDate:start], post.files.count);

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell configureWithObject:post];
    [self configureCell:(KGTableViewCell *)cell atIndexPath:indexPath];
    cell.transform = self.tableView.transform;
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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:[sectionInfo name]];
    NSString *dateName = [date dateFormatForMessageTitle];
    return dateName;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor kg_blackColor]];
    [header.textLabel setFont:[UIFont kg_bold16Font]];
    header.textLabel.textAlignment = NSTextAlignmentRight;
    header.textLabel.transform = self.tableView.transform;
    
    header.contentView.backgroundColor = [UIColor kg_whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.f;
}


#pragma mark - NSFetchedResultsController

- (void)setupFetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel = %@", self.channel];
    self.fetchedResultsController = [KGPost MR_fetchAllSortedBy:NSStringFromSelector(@selector(createdAt))
                                                      ascending:NO
                                                  withPredicate:predicate
                                                        groupBy:NSStringFromSelector(@selector(creationDay))
                                                       delegate:self
    ];
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
    if (!self.currentPost) {
        self.currentPost = [KGPost MR_createEntity];
    }
    self.currentPost.message = self.textInputbar.textView.text;
    self.currentPost.author = [[KGBusinessLogic sharedInstance] currentUser];
    self.currentPost.channel = self.channel;
    self.currentPost.createdAt = [NSDate date];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.currentPost setBackendPendingId:
            [NSString stringWithFormat:@"%@:%lf",[[KGBusinessLogic sharedInstance] currentUserId], [self.currentPost.createdAt timeIntervalSince1970]]];
    
    [[KGBusinessLogic sharedInstance] sendPost:self.currentPost completion:^(KGError *error) {
        self.textView.text = @"";
        if (error) {
            //FIXME обработка ошибок
        }

        self.currentPost = nil;
    }];
}


#pragma mark - Private

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell configureWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    cell.transform = self.tableView.transform;
}

- (void)assignPhotos {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{

            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;

            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}


#pragma mark - Notifications

- (void)test:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[KGChannelNotification class]]) {
        KGChannelNotification *kg_notification = notification.object;
        
        if (kg_notification.action == KGActionTyping) {
            KGUser *user = [KGUser managedObjectById:kg_notification.userIdentifier];
            [self.typingIndicatorView insertUsername:user.nickname];
        }
    }
}


#pragma mark -  CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    PHImageManager *manager = [PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    __block UIImage *img;
    __weak typeof(self) wSelf = self;

    [self dismissViewControllerAnimated:YES completion:^{
        [[KGAlertManager sharedManager] showProgressHud];
    }];
    
    dispatch_group_t group = dispatch_group_create();
    if (!self.currentPost) {
        self.currentPost = [KGPost MR_createEntity];
    }
    
    self.textInputbar.rightButton.enabled = NO;
    for (PHAsset *asset in assets) {
        dispatch_group_enter(group);
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeAspectFill
                              options:self.requestOptions
                        resultHandler:^(UIImage *image, NSDictionary *info) {
                            img = image;
                            [wSelf.assignedPhotos addObject:img];
                            NSString *localLink = [NSString stringWithFormat:@"temp_image_%d", wSelf.assignedPhotos.count];
                            [[SDImageCache sharedImageCache] storeImage:image forKey:localLink];
                            KGFile *imgFile = [KGFile MR_createEntity];
                           // imgFile.tempId = tempId;
                            [imgFile setBackendLink:localLink];
                            [self.currentPost addFilesObject:imgFile];
                            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

                            [[KGBusinessLogic sharedInstance] uploadFile:imgFile atChannel:wSelf.channel withCompletion:^(KGError *error) {
                                dispatch_group_leave(group);
                            }];
                        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[KGAlertManager sharedManager] hideHud];
        self.textInputbar.rightButton.enabled = YES;
        [self sendPost];
    });
}


#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (self.channel) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:self.channel.notificationsName object:nil];
    }

    self.channel = [KGChannel managedObjectById:idetnfifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:self.channel.notificationsName object:nil];
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

#pragma mark - KGRightMenuDelegate

- (void)navigationToProfil {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingsAccount" bundle:nil];
    KGPresentNavigationController *presentNC = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    presentNC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:presentNC animated:YES completion:nil];
    });
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
