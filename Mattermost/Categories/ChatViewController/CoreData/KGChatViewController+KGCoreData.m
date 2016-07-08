//
//  KGChatViewController+KGCoreData.m
//  Mattermost
//
//  Created by Igor Vedeneev on 04.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController+KGCoreData.h"
#import <CoreData/CoreData.h>
#import "KGTableViewCell.h"

@implementation KGChatViewController (KGCoreData)
#pragma mark - NSFetchedResultsControllerDelegate

// Todo, Code Review: Вынести в категорию.
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    
    self.deletedSections = [[NSMutableIndexSet alloc] init];
    self.insertedSections = [[NSMutableIndexSet alloc] init];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
     [self.tableView reloadRowsAtIndexPaths:@[self.lastPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            [self.deletedSections addIndexes:indexSet];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            // iOS 9.0b5 sends the same index path twice instead of delete
            if(![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationFade];
            }
            else if([self.insertedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: Moving first item from section 0 (which becomes section 1 later) to section 0
                // Really the only way is to delete and insert the same index path...
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
            }
            else if([self.deletedSections containsIndex:indexPath.section]) {
                // iOS 9.0b5 bug: same index path reported after section was removed
                // we can ignore item deletion here because the whole section was removed anyway
                [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
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

@end
