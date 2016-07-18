//
//  KGChatViewController.h
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "SLKTextViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "KGDateFormatter.h"
#import "KGAutoCompletionCell.h"
#import "KGChatAttachmentsTableViewCell.h"
#import "KGChatCommonTableViewCell.h"
#import "KGFollowUpChatCell.h"
#import "KGCommandTableViewCell.h"
#import "KGPost.h"
#import "KGTableViewSectionHeader.h"
#import "KGCommand.h"
#import "KGUser.h"
#import "KGFile.h"
#import "UIStatusBar+SharedBar.h"
#import "NSDate+DateFormatter.h"
#import "KGAlertManager.h"
#import "KGBusinessLogic+File.h"

static NSString *const kPresentProfileSegueIdentier = @"presentProfile";

@class KGTableViewCell, KGAutoCompletionCell, KGPost;

@interface KGChatViewController : SLKTextViewController <NSFetchedResultsControllerDelegate, IDMPhotoBrowserDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property NSMutableIndexSet *insertedSectionIndexes, *deletedSectionIndexes;
@property NSMutableArray* deletedRowIndexPaths, *insertedRowIndexPaths, * updatedRowIndexPaths;
@property (nonatomic, strong) NSArray *autocompletionDataSource;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign, getter=isCommandModeOn) BOOL commandModeOn;
@property (nonatomic, assign) BOOL shouldShowCommands;
@property (nonatomic, strong) KGCommand *selectedCommand;

@property (nonatomic, copy) NSString *selectedUsername;

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (KGAutoCompletionCell *)autoCompletionCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadNextPageOfData;
- (void)loadAdditionalPostFilesInfo:(KGPost *)post indexPath:(NSIndexPath *)indexPath;

- (void)errorActionWithPost:(KGPost *)post;

- (void)openFile:(KGFile *)file;
- (void)showProfile: (KGUser *)user;


@end
