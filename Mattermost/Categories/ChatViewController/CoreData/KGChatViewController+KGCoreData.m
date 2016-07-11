//
//  KGChatViewController+KGCoreData.m
//  Mattermost
//
//  Created by Igor Vedeneev on 04.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController+KGCoreData.h"
#import <CoreData/CoreData.h>

@implementation KGChatViewController (KGCoreData)
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    self.insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
    self.deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
    self.deletedRowIndexPaths = [[NSMutableArray alloc] init];
    self.insertedRowIndexPaths = [[NSMutableArray alloc] init];
    self.updatedRowIndexPaths = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
            // If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
            return;
        }
        
        [self.insertedRowIndexPaths addObject:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
            // If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
            return;
        }
        
        [self.deletedRowIndexPaths addObject:indexPath];
    } else if (type == NSFetchedResultsChangeMove) {
        if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
            [self.insertedRowIndexPaths addObject:newIndexPath];
        }
        
        if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
            [self.deletedRowIndexPaths addObject:indexPath];
        }
    } else if (type == NSFetchedResultsChangeUpdate) {
        [self.updatedRowIndexPaths addObject:indexPath];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.insertedSectionIndexes addIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [self.deletedSectionIndexes addIndex:sectionIndex];
            break;
        default:
            ; // Shouldn't have a default
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSInteger totalChanges = [self.deletedSectionIndexes count] +
    [self.insertedSectionIndexes count] +
    [self.deletedRowIndexPaths count] +
    [self.insertedRowIndexPaths count] +
    [self.updatedRowIndexPaths count];
    
    if (totalChanges > 120) {
        
        [self.tableView reloadData];
        return;
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[self.lastPath] withRowAnimation:UITableViewRowAnimationNone];
}




@end
