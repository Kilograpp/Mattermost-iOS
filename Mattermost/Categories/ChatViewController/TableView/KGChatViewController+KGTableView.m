//
//  KGChatViewController+KGTableView.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController+KGTableView.h"
#import "KGPhotoBrowser.h"
#import "KGHardwareUtils.h"

@implementation KGChatViewController (KGTableView)


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
    
    static NSInteger nextPageOffset = 0;
    
    if (nextPageOffset == 0) {
        if ([[KGHardwareUtils sharedInstance] devicePerformance] == KGPerformanceHigh){
            nextPageOffset = 30;
        } else {
            nextPageOffset = 10;
        }
    }
    
    // Todo, Code Review: Один метод делегата на две таблицы - это плохо, разнести по категориям
    if (![tableView isEqual:self.tableView]) {
        return [self autoCompletionCellAtIndexPath:indexPath];
    }
    
    NSString *reuseIdentifier;
    KGPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (self.hasNextPage && (self.fetchedResultsController.fetchedObjects.count - [self.fetchedResultsController.fetchedObjects indexOfObject:post] < nextPageOffset)) {
        [self loadNextPageOfData];
    }
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    // Todo, Code Review: Не понятное условие
    if (indexPath.row == [sectionInfo numberOfObjects] - 1) {//для первой ячейки
        reuseIdentifier = !post.hasAttachments ?
        [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
    } else {
        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
        NSInteger index = [self.fetchedResultsController.fetchedObjects indexOfObject:post];
        BOOL notBetweenPages = ((index+1) % 60 != 0 && (index % 60) != 0) || index == 0;
        if (postsHaveSameAuthor(post, prevPost) && [post timeIntervalSincePost:prevPost] < 3600 && notBetweenPages) {
            reuseIdentifier = !post.hasAttachments ?
            [KGFollowUpChatCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        } else {
            reuseIdentifier = !post.hasAttachments ?
            [KGChatCommonTableViewCell reuseIdentifier] : [KGChatAttachmentsTableViewCell reuseIdentifier];
        }
    }
    
    KGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [self assignBlocksForCell:cell post:post];
//    if (post.nonImageFiles) {
//        [self loadAdditionalPostFilesInfo:post indexPath:indexPath];
//    }
    
    [cell configureWithObject:post];
    cell.transform = self.tableView.transform;
    
    // Todo, Code Review: Фон ячейки должен конфигурироваться изнутри
    //    cell.backgroundColor = (!post.isUnread) ? [UIColor kg_lightLightGrayColor] : [UIColor kg_whiteColor];
    
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
            return !post.hasAttachments ?
            [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
        } else {
            NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            KGPost *prevPost = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
    
            NSInteger index = [self.fetchedResultsController.fetchedObjects indexOfObject:post];
            BOOL notBetweenPages = ((index+1) % 60 != 0 && (index % 60) != 0) || index == 0;

            if (postsHaveSameAuthor(post, prevPost) && [post timeIntervalSincePost:prevPost] < 3600 && notBetweenPages) {
                return !post.hasAttachments ?
                [KGFollowUpChatCell heightWithObject:post]  : [KGChatAttachmentsTableViewCell heightWithObject:post];
            } else {
                return !post.hasAttachments ?
                [KGChatCommonTableViewCell heightWithObject:post] : [KGChatAttachmentsTableViewCell heightWithObject:post];
            }
        }
    }
    //ячейка для autoCompletionView:
    // Todo, Code Review: Все датасорс методы для другой таблицы вынести в отдельную категорию
    return  self.shouldShowCommands ? [KGCommandTableViewCell heightWithObject:nil] : [KGAutoCompletionCell heightWithObject:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KGTableViewSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[KGTableViewSectionHeader reuseIdentifier]];
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    NSDate *date = [[KGDateFormatter sharedChatHeaderDateFormatter] dateFromString:[sectionInfo name]];
    NSString *dateName = [date dateFormatForMessageTitle];
    [header configureWithObject:dateName];
    header.dateLabel.transform = self.tableView.transform;
    
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    //    view.backgroundColor = [UIColor kg_whiteColor];
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


#pragma mark - Public


#pragma mark - Private

- (void)assignBlocksForCell:(KGTableViewCell *)cell post:(KGPost *)post {
    cell.photoTapHandler = ^(NSUInteger selectedPhoto, UIView *view) {
        NSArray *urls = [post.sortedFiles valueForKeyPath:NSStringFromSelector(@selector(downloadLink))];
        KGPhotoBrowser *browser = [[KGPhotoBrowser alloc] initWithPhotoURLs:urls];
        [[UIStatusBar sharedStatusBar] moveTemporaryToRootView];
        [browser setDelegate:self];
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
        if (!([nickname isEqualToString:@"channel"] || [nickname isEqualToString:@"all"])){
            self.selectedUsername = nickname;
            [self performSegueWithIdentifier:kPresentProfileSegueIdentier sender:nil];
        }
    };
    cell.errorTapHandler = ^(KGPost *post) {
        [self errorActionWithPost: post];
    };
    
    if ([cell isKindOfClass:[KGChatCommonTableViewCell class]]){
        cell.profileTapHandler = ^(KGUser *user) {
            [self showProfile:post.author];
        };
    }
}

@end
