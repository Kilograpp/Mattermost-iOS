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
#import <QuickLook/QuickLook.h>
#import "NSMutableURLRequest+KGHandleCookies.h"
#import "UIStatusBar+SharedBar.h"
#import "KGPreferences.h"
#import "KGBusinessLogic+Commands.h"
#import "KGImagePickerController.h"
#import "KGAction.h"
#import "KGChatViewController+KGCoreData.h"
#import "KGCommand.h"
#import "KGCommandTableViewCell.h"

static NSString *const kPresentProfileSegueIdentier = @"presentProfile";
static NSString *const kShowSettingsSegueIdentier = @"showSettings";

static NSString *const kUsernameAutocompletionPrefix = @"@";
static NSString *const kCommandAutocompletionPrefix = @"/";

@interface KGChatViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, KGLeftMenuDelegate, NSFetchedResultsControllerDelegate,
                            KGRightMenuDelegate, CTAssetsPickerControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) KGChannel *channel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) NSString *previousMessageAuthorId;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) KGPost *currentPost;
@property (nonatomic, strong) NSArray *searchResultArray;
@property (nonatomic, strong) NSArray *autocompletionDataSource;
@property (nonatomic, copy) NSString *selectedUsername;
@property (assign) BOOL isFirstLoad;
@property (weak, nonatomic) IBOutlet UILabel *noMessadgesLabel;
@property (assign) BOOL loadingInProgress;
@property (assign) BOOL hasNextPage;

@property (nonatomic, assign, getter=isCommandModeOn) BOOL commandModeOn;
@property (nonatomic, assign) BOOL shouldShowCommands;
@property (nonatomic, strong) KGCommand *selectedCommand;
@property (nonatomic, strong) UIActivityIndicatorView *topActivityIndicator;

- (IBAction)rightBarButtonAction:(id)sender;

@end

@implementation KGChatViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
    [self setupTableView];
    [self setupAutocompletionView];
    [self setupIsNoMessagesLabelShow:YES];
    [self setupKeyboardToolbar];
    [self setupLeftBarButtonItem];
    [self setupRefreshControl];
    [self registerObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Todo, Code Review: Нарушение абстракции
    [self.textView isFirstResponder];
    [self.textView resignFirstResponder];
    [self.textView refreshFirstResponder];
    [self setNeedsStatusBarAppearanceUpdate];
    [IQKeyboardManager sharedManager].enable = NO;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (_isFirstLoad) {
        [self replaceStatusBar];
        _isFirstLoad = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Todo, Code Review: Нарушение абстракции
    if ([self isMovingFromParentViewController]) {
        self.navigationController.delegate = nil;
    }
}

// Todo, Code Review: Нарушение абстракции, вынести отписку в отдельный метод
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Setup

- (void)initialSetup {
      _isFirstLoad = YES;
    self.navigationController.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    KGLeftMenuViewController *leftVC = (KGLeftMenuViewController *)self.menuContainerViewController.leftMenuViewController;
    KGRightMenuViewController *rightVC  = (KGRightMenuViewController *)self.menuContainerViewController.rightMenuViewController;
    leftVC.delegate = self;
    rightVC.delegate = self;
    self.shouldClearTextAtRightButtonPress = NO;
    self.autoCompletionView.backgroundColor = [UIColor kg_autocompletionViewBackgroundColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setupTableView {
    [self.tableView registerClass:[KGChatAttachmentsTableViewCell class]
           forCellReuseIdentifier:[KGChatAttachmentsTableViewCell reuseIdentifier] cacheSize:5];
    [self.tableView registerClass:[KGChatCommonTableViewCell class]
           forCellReuseIdentifier:[KGChatCommonTableViewCell reuseIdentifier] cacheSize:7];
    [self.tableView registerClass:[KGFollowUpChatCell class]
           forCellReuseIdentifier:[KGFollowUpChatCell reuseIdentifier] cacheSize:10];

    [self.tableView registerNib:[KGTableViewSectionHeader nib]
            forHeaderFooterViewReuseIdentifier:[KGTableViewSectionHeader reuseIdentifier]];

    [self.tableView registerNib:[KGAutoCompletionCell nib]
         forCellReuseIdentifier:[KGAutoCompletionCell reuseIdentifier] cacheSize:15];
    [self.tableView registerNib:[KGCommandTableViewCell nib]
         forCellReuseIdentifier:[KGCommandTableViewCell reuseIdentifier] cacheSize:15];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor kg_whiteColor];
}

- (void)setupKeyboardToolbar {
    [self setupTextView];
    [self setupInputBarRightButton];
    [self setupTextInputBar];
}

- (void)setupTextInputBar {
    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.textView.font = [UIFont kg_regular15Font];
    self.textInputbar.textView.placeholder = NSLocalizedString(@"Type something...", nil);
    self.textInputbar.textView.layer.borderWidth = 0.f;
    self.textInputbar.translucent = NO;
    self.textInputbar.barTintColor = [UIColor kg_whiteColor];
}

- (void)setupInputBarRightButton {
    self.rightButton.titleLabel.font = [UIFont kg_semibold16Font];
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(sendPost) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(assignPhotos) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTextView {
    self.textView.delegate = self;
}

- (void)setupAutocompletionView {
    [self registerPrefixesForAutoCompletion:@[ kUsernameAutocompletionPrefix, kCommandAutocompletionPrefix ]];
}

- (void)setupLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_button"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(toggleLeftSideMenuAction)];
}

// Todo, Code Review: Разделить на два разных метода, аргумент тут не к месту
- (void)setupIsNoMessagesLabelShow:(BOOL)isShow {
    self.noMessadgesLabel.hidden = isShow;
    if (isShow) {
        [self.view bringSubviewToFront:self.noMessadgesLabel];
    }
    
}

#pragma mark - SLKViewController

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder{
    return UITableViewStyleGrouped;
}

- (void)didChangeAutoCompletionPrefix:(NSString *)prefix andWord:(NSString *)word {
    NSString *filterTerm;
    
    if ([prefix isEqualToString:kUsernameAutocompletionPrefix]) {
        filterTerm = [KGUserAttributes username];
        self.autocompletionDataSource = [KGUser MR_findAll];
    } else  if ([prefix isEqualToString:kCommandAutocompletionPrefix]) {
        filterTerm = [KGCommandAttributes trigger];
        self.autocompletionDataSource = [KGCommand MR_findAll];
    }

    if (word.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ BEGINSWITH[c] %@", filterTerm, word];
        self.autocompletionDataSource = [self.autocompletionDataSource filteredArrayUsingPredicate:predicate];
    }

    BOOL show = (self.autocompletionDataSource.count > 0);
    self.shouldShowCommands = [prefix isEqualToString:kCommandAutocompletionPrefix];
    [self showAutoCompletionView:show];
}

- (CGFloat)heightForAutoCompletionView {
    CGFloat cellHeight = self.shouldShowCommands ? [KGCommandTableViewCell heightWithObject:nil] : [KGAutoCompletionCell heightWithObject:nil];
    return cellHeight * self.autocompletionDataSource.count;
}

- (CGFloat)maximumHeightForAutoCompletionView {
    return self.tableView.bounds.size.height;
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
    
    return self.autocompletionDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Todo, Code Review: Один метод делегата на две таблицы - это плохо, разнести по категориям
    if (![tableView isEqual:self.tableView]) {
        return [self autoCompletionCellAtIndexPath:indexPath];
    }
    
    

    
    NSString *reuseIdentifier;
    KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (self.hasNextPage && (self.fetchedResultsController.fetchedObjects.count - [self.fetchedResultsController.fetchedObjects indexOfObject:post] == 3)) {
        [self loadNextPageOfData];
    }

    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    // Todo, Code Review: Не понятное условие
    if (indexPath.row == [sectionInfo numberOfObjects] - 1) {//для первой ячейки
        reuseIdentifier = post.files.count == 0 ?
                [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
    } else {
        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
        // Todo, Code Review: TimeIntervalSinceDate заменить на minutesEarlierThan из DateTools и вставить пять минут. Вообще, следует вынести сравнение дат с пятиминутным интервалом в категорию даты дополнительно.
        // Todo, Code Review: PrevPost и Post сравнение авторов надо сделать нормальным методов внутри поста, а не так в контроллере.
        // Todo, Code Review: Двойные условия на проверку attachment. Ее надо вынести глобально, а не трижды(см. выше) проверять внутри каждого условия
        if ([prevPost.author.identifier isEqualToString:post.author.identifier] && [post.createdAt timeIntervalSinceDate:prevPost.createdAt] < 3600) {
            reuseIdentifier = post.files.count == 0 ?
                    [KGFollowUpChatCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        } else {
            reuseIdentifier = post.files.count == 0 ?
                    [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        }
    }

    KGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    [cell startAnimation];
    [self assignBlocksForCell:cell post:post];
    
    if (post.nonImageFiles) {
        [self loadAdditionalPostFilesInfo:post indexPath:indexPath];
    }

    [cell configureWithObject:post];
    
    cell.transform = self.tableView.transform;
    // Todo, Code Review: Фон ячейки должен конфигурироваться изнутри
    cell.backgroundColor = (!post.isUnread) ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
    //[cell finishAnimation];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Todo, Code Review: Отдельная категория, см. выше
    if ([tableView isEqual:self.tableView]) {
        KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[(NSUInteger) indexPath.section];

        // Todo, Code Review: Условие на файлы см. выше
        if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
            return post.files.count == 0 ?
                    [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
        } else {
            NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
            // Todo, Code Review: Условие на даты см. выше
            if ([prevPost.author.identifier isEqualToString:post.author.identifier] && [post.createdAt timeIntervalSinceDate:prevPost.createdAt] < 3600) {
                return post.files.count == 0 ?
                        [KGFollowUpChatCell heightWithObject:post]  : [KGChatAttachmentsTableViewCell heightWithObject:post];;
            } else {
                return post.files.count == 0 ?
                        [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
            }
        }

        // Todo, Code Review: Мертвое условие
        return 0.f;
    }
    //ячейка для autoCompletionView:
    // Todo, Code Review: Все датасорс методы для другой таблицы вынести в отдельную категорию
    return  self.shouldShowCommands ? [KGCommandTableViewCell heightWithObject:nil] : [KGAutoCompletionCell heightWithObject:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KGTableViewSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[KGTableViewSectionHeader reuseIdentifier]];
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    // Todo, Code Review: Формат даты надо выносить в глобальные
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:[sectionInfo name]];
    NSString *dateName = [date dateFormatForMessageTitle];
    [header configureWithObject:dateName];
    header.backgroundColor  = [UIColor whiteColor];
    header.dateLabel.transform = self.tableView.transform;
    return header;

}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [tableView isEqual:self.autoCompletionView] ? [UIColor kg_autocompletionViewBackgroundColor] : [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.tableView isEqual:self.tableView] ? CGFLOAT_MIN : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return [KGTableViewSectionHeader height];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Todo, Code Review: В отдельную категорию делегаты для autocompletion
    if ([tableView isEqual:self.autoCompletionView]) {

        // Todo, Code Review: В отдельный метод, который должен скрывать auto-completion view
        if (self.shouldShowCommands) {
            KGCommand *command = self.autocompletionDataSource[indexPath.row];
            [self acceptAutoCompletionWithString:[command.trigger stringByAppendingString:@" "] keepPrefix:YES];
            [self cancelAutoCompletion];
        } else {
            KGUser *user = self.autocompletionDataSource[indexPath.row];
            [self acceptAutoCompletionWithString:[user.username stringByAppendingString:@" "] keepPrefix:YES];
        }
    }
}


#pragma mark - NSFetchedResultsController

- (void)setupFetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channel = %@", self.channel];
    self.fetchedResultsController = [KGPost MR_fetchAllSortedBy:[KGPostAttributes createdAt]
                                                      ascending:NO
                                                  withPredicate:predicate
                                                        groupBy:[KGPostAttributes creationDay]
                                                       delegate:self
                                     ];

    self.fetchedResultsController.fetchedObjects.count == 0 ?
            [self setupIsNoMessagesLabelShow:NO] : [self setupIsNoMessagesLabelShow:YES];
}


#pragma mark - Requests

- (void)loadFirstPageOfData {
    self.loadingInProgress = YES;
    [[KGBusinessLogic sharedInstance] loadFirstPageForChannel:self.channel completion:^(BOOL isLastPage, KGError *error) {
        [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.05];
        if (error) {
            [[KGAlertManager sharedManager] showError:error];
        }
        [self setupFetchedResultsController];
        [self.tableView reloadData];
        [self hideLoadingViewAnimated:YES];
        self.loadingInProgress = NO;
        self.hasNextPage = !isLastPage;
    }];
}

- (void)loadNextPageOfData {
    if (self.loadingInProgress || !self.hasNextPage) {
        return;
    }
    
    self.loadingInProgress = YES;
    [self showTopActivityIndicator];
    [[KGBusinessLogic sharedInstance] loadNextPageForChannel:self.channel completion:^(BOOL isLastPage, KGError *error) {
        if (error) {
            [[KGAlertManager sharedManager] showError:error];
        }
        [self hideTopActivityIndicator];
        self.loadingInProgress = NO;
        self.hasNextPage = !isLastPage;
    }];
}


- (void)sendPost {

    // Todo, Code Review: Не соблюдение абстаркции, вынести конфигурацию сообщения для отправки в отдельный метод
    // Todo, Code Review: Вынести создание пустой сущности в геттер

    
    if ([self.textInputbar.textView.text hasPrefix:kCommandAutocompletionPrefix]) {

        [[KGBusinessLogic sharedInstance] executeCommandWithMessage:self.textInputbar.textView.text
                                                          inChannel:self.channel withCompletion:^(KGAction *action, KGError *error) {
                    [action execute];
                }];
        self.textView.text = @"";
        return;
    }

    if (!self.currentPost) {
        self.currentPost = [KGPost MR_createEntity];
    }
    self.currentPost.message = self.textInputbar.textView.text;
    self.currentPost.author = [[KGBusinessLogic sharedInstance] currentUser];
    self.currentPost.channel = self.channel;
    self.currentPost.createdAt = [NSDate date];
    self.textView.text = @"";
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    // Todo, Code Review: Не соблюдение абстракции, вынести в отдельный метод внутрь поста
    [self.currentPost setBackendPendingId:
            [NSString stringWithFormat:@"%@:%lf",[[KGBusinessLogic sharedInstance] currentUserId],
                                                 [self.currentPost.createdAt timeIntervalSince1970]]];
    [[KGBusinessLogic sharedInstance] sendPost:self.currentPost completion:^(KGError *error) {
        if (error) {
            self.currentPost.error = @YES;
            [[KGAlertManager sharedManager] showError:error];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }

        // Todo, Code Review: Не соблюдение абстракции, вынести сброс текущего поста в отдельный метод
            self.currentPost = nil;
    }];
}


- (void)loadAdditionalPostFilesInfo:(KGPost *)post indexPath:(NSIndexPath *)indexPath {
    NSArray *files = post.nonImageFiles;
    
    for (KGFile *file in files) {
        if (file.sizeValue == 0) {
            [[KGBusinessLogic sharedInstance] updateFileInfo:file withCompletion:^(KGError *error) {
                if (error) {
                    [[KGAlertManager sharedManager] showError:error];
                } else {
                    KGTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    [cell configureWithObject:post];
                }
            }];
        }
    }
}


#pragma mark - Private

- (KGAutoCompletionCell *)autoCompletionCellAtIndexPath:(NSIndexPath *)indexPath {
    KGAutoCompletionCell *cell;
    NSString *reuseIdentifier = self.shouldShowCommands ?
                                        [KGCommandTableViewCell reuseIdentifier] : [KGAutoCompletionCell reuseIdentifier];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell configureWithObject:self.autocompletionDataSource[indexPath.row]];
    
    return cell;
}

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Todo, Code Review: Лишнее, если конфигурация autocompletion будет из категории
    if ([cell isKindOfClass:[KGTableViewCell class]]) {
//        [cell startAnimation];
        [cell configureWithObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        cell.transform = self.tableView.transform;
    }
}

- (void)assignPhotos {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCameraAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        picker.modalPresentationStyle = UIModalPresentationFormSheet;
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    }];
    
    UIAlertAction *openGalleryAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take from library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                picker.delegate = self;
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
            }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:openCameraAction];
    [alertController addAction:openGalleryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentPickerControllerWithType:(UIImagePickerControllerSourceType)type {
    KGImagePickerController *pickerController = [[KGImagePickerController alloc] init];
    pickerController.sourceType = type;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

// Todo, Code Review: Каша из асбтракции
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

- (void)assignBlocksForCell:(KGTableViewCell *)cell post:(KGPost *)post {
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
                                                  } completion:^(KGError *error) {
                                                      if (error) {
                                                          [[KGAlertManager sharedManager]showError:error];
                                                      }
                                                      [[KGAlertManager sharedManager] hideHud];
                                                      [self openFile:file];
                                                  }];
        }
    };
    
    cell.mentionTapHandler = ^(NSString *nickname) {
        self.selectedUsername = nickname;
        [self performSegueWithIdentifier:kPresentProfileSegueIdentier sender:nil];
    };

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)replaceStatusBar {
    [[UIStatusBar sharedStatusBar] moveToView:self.navigationController.view ];
}

#pragma mark - Notifications

- (void)performFillingTypingIndicatorView:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[KGChannelNotification class]]) {
        KGChannelNotification *kg_notification = notification.object;
        //проверка на то, что текущий юзер != юзеру, который пишет

        switch (kg_notification.action) {
            case KGActionTyping: {
                NSString *currentUserID = [[KGPreferences sharedInstance] currentUserId];
                KGUser *user = [KGUser managedObjectById:kg_notification.userIdentifier];
                if (![user.identifier isEqualToString:currentUserID]) {
                    [self.typingIndicatorView insertUsername:user.nickname];
                }
                break;
            }

            case KGActionPosted: {
                KGUser *user = [KGUser managedObjectById:kg_notification.userIdentifier];
                [self.typingIndicatorView removeUsername: user.nickname];
                break;
            }

            default:
                break;
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

// Todo, Code Review: Каша из абстракции
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        [[KGAlertManager sharedManager] showProgressHud];
    }];
    
    __weak typeof(self) wSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [[KGAlertManager sharedManager] showProgressHud];
    }];
        dispatch_group_t group = dispatch_group_create();
    if (!self.currentPost) {
        self.currentPost = [KGPost MR_createEntity];
    }
    dispatch_group_enter(group);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                            [[KGBusinessLogic sharedInstance] uploadImage:[image kg_normalizedImage]
                                                                atChannel:wSelf.channel
                                                           withCompletion:^(KGFile* file, KGError* error) {
                                                               [self.currentPost addFilesObject:file];
                                                               dispatch_group_leave(group);
                                                           }];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
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

// Todo, Code Review: Каша из абстракции
- (void)didSelectChannelWithIdentifier:(NSString *)idetnfifier {
    [self dismissKeyboard:YES];
    if (self.channel) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:self.channel.notificationsName
                                                      object:nil];
    }

    self.channel = [KGChannel managedObjectById:idetnfifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFillingTypingIndicatorView:)
                                                 name:self.channel.notificationsName
                                               object:nil];
    [self updateNavigationBarAppearance];
    // Todo, Code Review: Мертвый код
    self.channel.lastViewDate = [NSDate date];
    [self.tableView slk_scrollToTopAnimated:NO];

    [[KGBusinessLogic sharedInstance] loadExtraInfoForChannel:self.channel withCompletion:^(KGError *error) {
        if (error) {
            [[KGAlertManager sharedManager] showError:error];
        } else {
            [self updateNavigationBarAppearance];
            NSTimeInterval interval = self.channel.updatedAt.timeIntervalSinceNow;
            //FIXME: refactor
            if ([self.channel.firstLoaded boolValue] || self.channel.hasNewMessages || fabs(interval) > 1000) {
                self.channel.lastViewDate = [NSDate date];
                self.channel.firstLoadedValue = NO;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [self showLoadingView];
                [self loadFirstPageOfData];
            } else {
                [self setupFetchedResultsController];
                [self.tableView reloadData];
            }
        }
    }];

    [[KGBusinessLogic sharedInstance] updateLastViewDateForChannel:self.channel withCompletion:nil];
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

- (void)navigateToSettings {
    [self performSegueWithIdentifier:kShowSettingsSegueIdentier sender:nil];
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
//    if (!_loadingView) {
        self.loadingView = [[UIView alloc] init];
        self.loadingView.backgroundColor = [UIColor whiteColor];
//    }

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
    NSTimeInterval duration = animated ? KGStandartAnimationDuration : 0;
    
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
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadFirstPageOfData];
}


#pragma mark - ActivityIndicator

- (void)showTopActivityIndicator {
    CGFloat bottomActivityIndicatorHeight = CGRectGetHeight(self.topActivityIndicator.bounds);
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 2 * bottomActivityIndicatorHeight)];
    self.topActivityIndicator.center = CGPointMake(tableFooterView.center.x, tableFooterView.center.y - bottomActivityIndicatorHeight / 5);
    [tableFooterView addSubview:self.topActivityIndicator];
    self.tableView.tableFooterView = tableFooterView;
    [self.topActivityIndicator startAnimating];
}

- (void)hideTopActivityIndicator {
    [self.topActivityIndicator stopAnimating];
    if (!self.hasNextPage) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (UIActivityIndicatorView *)topActivityIndicator {
    if (!_topActivityIndicator) {
        _topActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _topActivityIndicator.transform = self.tableView.transform;
    }
    
    return _topActivityIndicator;
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


#pragma mark - Private Setters

- (void)setShouldShowCommands:(BOOL)shouldShowCommands {
    if (shouldShowCommands != _shouldShowCommands) {
        [self.autoCompletionView reloadData];
    }
    self.autoCompletionView.separatorStyle = shouldShowCommands ?
            UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;

    _shouldShowCommands = shouldShowCommands;
}


#pragma mark - Files
// Todo, Code Review: Вынести в бизнес логику
- (void)openFile:(KGFile *)file {
    NSURL *URL = [NSURL fileURLWithPath:file.localLink];

    if (URL) {
        UIDocumentInteractionController *documentInteractionController =
                [UIDocumentInteractionController interactionControllerWithURL:URL];
        [documentInteractionController setDelegate:self];
        [documentInteractionController presentPreviewAnimated:YES];
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [super textView:textView shouldChangeTextInRange:range replacementText:text];
    
    return YES;
}

@end
