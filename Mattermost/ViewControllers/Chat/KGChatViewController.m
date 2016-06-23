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
#import "KGAutoCompletionCell.h"
#import "KGChannelNotification.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGFile.h"
#import "KGAlertManager.h"
#import "UIImage+KGRotate.h"
#import <UITableView_Cache/UITableView+Cache.h>
#import "KGNotificationValues.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "UIImage+Resize.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "KGTableViewSectionHeader.h"
#import "KGProfileTableViewController.h"
#import "KGChatRootCell.h"
#import "UIImage+Resize.h"
#import <objc/runtime.h>
#import <QuickLook/QuickLook.h>

static NSString *const kPresentProfileSegueIdentier = @"presentProfile";

@interface KGChatViewController () <UINavigationControllerDelegate, KGLeftMenuDelegate,
                            NSFetchedResultsControllerDelegate, KGRightMenuDelegate, CTAssetsPickerControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) NSString *previousMessageAuthorId;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) KGPost *currentPost;
@property (nonatomic, strong) NSArray *searchResultArray;
@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, copy) NSString *selectedUsername;
@property NSMutableIndexSet *deletedSections, *insertedSections;


- (IBAction)rightBarButtonAction:(id)sender;

@end

@implementation KGChatViewController

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder{
    return UITableViewStyleGrouped;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupTableView];
    [self setupKeyboardToolbar];
    [self setupLeftBarButtonItem];
    [self setupRefreshControl];
    [self registerObservers];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.tableView registerClass:[KGChatAttachmentsTableViewCell class]
           forCellReuseIdentifier:[KGChatAttachmentsTableViewCell reuseIdentifier] cacheSize:5];
    [self.tableView registerClass:[KGChatCommonTableViewCell class]
           forCellReuseIdentifier:[KGChatCommonTableViewCell reuseIdentifier] cacheSize:15];
    [self.tableView registerNib:[KGFollowUpChatCell nib]
         forCellReuseIdentifier:[KGFollowUpChatCell reuseIdentifier] cacheSize:15];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KGTableViewSectionHeader class]) bundle:nil]
            forHeaderFooterViewReuseIdentifier:[KGTableViewSectionHeader reuseIdentifier]];

    [self.tableView registerNib:[KGAutoCompletionCell nib]
         forCellReuseIdentifier:[KGAutoCompletionCell reuseIdentifier] cacheSize:15];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
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
    [self registerPrefixesForAutoCompletion:@[@"@"]];
}

- (void)setupLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(toggleLeftSideMenuAction)];
}


#pragma mark - SLKViewController

- (void)didChangeAutoCompletionPrefix:(NSString *)prefix andWord:(NSString *)word{
    //SLKTextViewController - поиск по предикату
    self.usersArray = [KGUser MR_findAll];
    
    if ([prefix isEqualToString:@"@"] && word.length > 0) {
        self.searchResultArray = [[self.usersArray valueForKey:@"username"]
                                  filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", word]];
        
    }
    
    BOOL show = (self.searchResultArray.count > 0);
    [self showAutoCompletionView:show];
}

- (CGFloat)heightForAutoCompletionView {
    //SLKTextViewController
    CGFloat cellHeight = [KGAutoCompletionCell heightWithObject:nil];
    return cellHeight*self.searchResultArray.count;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![tableView isEqual:self.tableView]) {
        return 1;
    }
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
        return [sectionInfo numberOfObjects];
    }
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEqual:self.tableView]) {
        //ячейка для autoCompletionView
        NSMutableString *item = [self.searchResultArray[indexPath.row] mutableCopy];
        KGUser *user =[KGUser managedObjectByUserName:item];
        KGAutoCompletionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[KGAutoCompletionCell reuseIdentifier]];
        [cell configureWithObject:user];
        return cell;
    }
    NSString *reuseIdentifier;
    KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    KGFile *f;
    if ([post.files allObjects].count){
   f = [[post.files allObjects] objectAtIndex:0];
    }
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    
    if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
        reuseIdentifier = post.files.count == 0 ?
                [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
    } else {
        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
        if ([prevPost.author.identifier isEqualToString:post.author.identifier]) {
            reuseIdentifier = post.files.count == 0 ?
                    [KGFollowUpChatCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        } else {
            reuseIdentifier = post.files.count == 0 ?
                    [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        }
    }

    KGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    cell.photoTapHandler = ^(NSUInteger selectedPhoto, UIView *view) {
        NSArray *urls = [post.sortedFiles valueForKeyPath:NSStringFromSelector(@selector(downloadLink))];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:urls animatedFromView:view];
        [browser setInitialPageIndex:selectedPhoto];
        [self presentViewController:browser animated:YES completion:nil];
    };
    
    cell.fileTapHandler = ^(NSUInteger selectedFile) {
        KGFile *file = post.sortedFiles[selectedFile];
        
        if (file.localLink) {
            [self openFile:file];
        } else {
            [[KGAlertManager sharedManager] showProgressHud];
            [[KGBusinessLogic sharedInstance] downloadFile:file
              progress:^(NSUInteger persentValue) {
                  NSLog(@"%d", persentValue);
            } completion:^(KGError *error) {
                [[KGAlertManager sharedManager] hideHud];
                [self openFile:file];
            }];
        }
    };

    cell.mentionTapHandler = ^(NSString *nickname) {
        self.selectedUsername = nickname;
        [self performSegueWithIdentifier:kPresentProfileSegueIdentier sender:nil];
    };
    
    [cell configureWithObject:post];
    cell.transform = self.tableView.transform;
    cell.backgroundColor = (!post.isUnread) ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger) indexPath.section];
        
        if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
            return post.files.count == 0 ?
                    [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
        } else {
            NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
            if ([prevPost.author.identifier isEqualToString:post.author.identifier]) {
                return post.files.count == 0 ?
                        [KGFollowUpChatCell heightWithObject:post]  : [KGChatAttachmentsTableViewCell heightWithObject:post];;
            } else {
                return post.files.count == 0 ?
                        [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
            }
        }
        
        return 0.f;
    }
    //ячейка для autoCompletionView:
    return [KGAutoCompletionCell heightWithObject:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KGTableViewSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[KGTableViewSectionHeader reuseIdentifier]];
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:[sectionInfo name]];
    NSString *dateName = [date dateFormatForMessageTitle];
    [header configureWithObject:dateName];
    header.backgroundColor  = [UIColor whiteColor];
    header.dateLabel.transform = self.tableView.transform;
    return header;

}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    
    v.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
    //return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return 50.f;
    } else {
        //для autoCompletionView
        return CGFLOAT_MIN;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.autoCompletionView]) {
        
        NSMutableString *item = [self.searchResultArray[indexPath.row] mutableCopy];
        [item appendString:@" "]; // Adding a space helps dismissing the auto-completion view
        
        [self acceptAutoCompletionWithString:item keepPrefix:YES];
    }
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

- (void)loadLastPostsWithRefreshing:(BOOL)isRefreshing {
    [[KGBusinessLogic sharedInstance] loadPostsForChannel:self.channel page:@0 size:@60 completion:^(KGError *error) {
        if (isRefreshing) {
            [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.05];
        }
        if (error) {
            if (!isRefreshing) {
                [self hideLoadingViewAnimated:YES];
            }
            [[KGAlertManager sharedManager] showError:error];
        }
        [self setupFetchedResultsController];
        [self.tableView reloadData];
        if (!isRefreshing) {
            [self hideLoadingViewAnimated:YES];
        }
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
    self.textView.text = @"";
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.currentPost setBackendPendingId:
            [NSString stringWithFormat:@"%@:%lf",[[KGBusinessLogic sharedInstance] currentUserId],
                                                 [self.currentPost.createdAt timeIntervalSince1970]]];
    
    [[KGBusinessLogic sharedInstance] sendPost:self.currentPost completion:^(KGError *error) {
        if (error) {
           [[KGAlertManager sharedManager] showError:error];
        }

        self.currentPost = nil;
    }];
}


#pragma mark - Private

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[KGTableViewCell class]]) {
        [cell configureWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        cell.transform = self.tableView.transform;
    }
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

- (void)updateNavigationBarAppearance {
    NSString *subtitleString;
    BOOL shouldHighlight = NO;
    if (self.channel.type == KGChannelTypePrivate) {
        KGUser *user = [KGUser managedObjectById:self.channel.interlocuterId];
        if (user) {
            subtitleString = user.stringFromNetworkStatus;
            shouldHighlight = user.networkStatus == KGUserOnlineStatus;
        }
    } else {
        subtitleString = [NSString stringWithFormat:@"%d members", (int)self.channel.members.count];
    }

    [(KGChatNavigationController *)self.navigationController setupTitleViewWithUserName:self.channel.displayName
                                                                               subtitle:subtitleString
                                                                        shouldHighlight:shouldHighlight];
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

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNavigationBarAppearance)
                                                 name:KGNotificationUsersStatusUpdate
                                               object:nil];
}


#pragma mark -  CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    PHImageManager *manager = [PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

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
                            [[KGBusinessLogic sharedInstance] uploadImage:[image kg_normalizedImage]
                                                                atChannel:wSelf.channel
                                withCompletion:^(KGFile* file, KGError* error) {
                                    [self.currentPost addFilesObject:file];
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


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([navigationController isKindOfClass:[KGChatNavigationController class]]) {
        if (navigationController.viewControllers.count == 1) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu_icon"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(toggleLeftSideMenuAction)];

        }
    }
}


#pragma mark - KGLeftMenuDelegate

- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier {
    [self showLoadingView];
    if (self.channel) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:self.channel.notificationsName
                                                      object:nil];
    }

    self.channel = [KGChannel managedObjectById:idetnfifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(test:)
                                                 name:self.channel.notificationsName
                                               object:nil];
    [self updateNavigationBarAppearance];
    //self.channel.lastViewDate = [NSDate date];
    [self.tableView slk_scrollToTopAnimated:NO];
    

        [[KGBusinessLogic sharedInstance] loadExtraInfoForChannel:self.channel withCompletion:^(KGError *error) {
                if ([self.channel.firstLoaded boolValue] || self.channel.hasNewMessages ) {
                    [self loadLastPostsWithRefreshing:NO];
                    self.channel.lastViewDate = [NSDate date];
                    self.channel.firstLoadedValue = NO;
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                } else {
                    [self setupFetchedResultsController];
                    [self.tableView reloadData];
                    [self hideLoadingViewAnimated:YES];
                }
        }];

}

#pragma mark - KGRightMenuDelegate

- (void)navigationToProfile {
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

- (IBAction)rightBarButtonAction:(id)sender {
    [self toggleRightSideMenuAction];
}

#pragma mark - Loading View

- (UIActivityIndicatorView *)loadingActivityIndicator {
    if (!_loadingActivityIndicator) {
        _loadingActivityIndicator = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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


#pragma mark - RefreshControl

- (void)setupRefreshControl {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
  //  [self.tableView addSubview:self.refreshControl];
   // [self.tableView sendSubviewToBack: self.refreshControl];
    
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadLastPostsWithRefreshing:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPresentProfileSegueIdentier]) {
        UINavigationController *nc = segue.destinationViewController;
        KGProfileTableViewController *vc = nc.viewControllers.firstObject;
        KGUser *user = [KGUser
                MR_findFirstByAttribute:NSStringFromSelector(@selector(username)) withValue:self.selectedUsername];
        vc.userId = user.identifier;
    }
}


- (void)openFile:(KGFile *)file {
    NSURL *URL = [NSURL fileURLWithPath:file.localLink];
    
    if (URL) {
        UIDocumentInteractionController *documentInteractionController =
                [UIDocumentInteractionController interactionControllerWithURL:URL];
        [documentInteractionController setDelegate:self];
        //        [documentInteractionController presentOpenInMenuFromRect:CGRectMake(200, 200, 100, 100) inView:self.view animated:YES];
        [documentInteractionController presentPreviewAnimated:YES];
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

@end
