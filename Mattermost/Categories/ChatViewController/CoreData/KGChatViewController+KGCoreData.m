//
//  KGChatViewController+KGCoreData.m
//  Mattermost
//
//  Created by Igor Vedeneev on 04.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController+KGCoreData.h"
#import "KGPost.h"
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(KGPost*)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    
    if (type == NSFetchedResultsChangeInsert) {
        if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
            if ([self.insertedRowIndexPaths containsObject:indexPath]) {
                [self rowShouldBeUpdatedAtIndexPath:indexPath];
            }
            // If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
            return;
        }
        
        [self.insertedRowIndexPaths addObject:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
            if ([self.insertedRowIndexPaths containsObject:indexPath]) {
                [self rowShouldBeUpdatedAtIndexPath:indexPath];
            }
            // If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
            return;
        }
        
        [self.deletedRowIndexPaths addObject:indexPath];
    } else if (type == NSFetchedResultsChangeMove) {
        
        if ([indexPath isEqual:newIndexPath]) {
            return;
        }
        
        if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
            [self.insertedRowIndexPaths addObject:newIndexPath];
        }
        
        if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
            [self.deletedRowIndexPaths addObject:indexPath];
        }
    } else if (type == NSFetchedResultsChangeUpdate) {
        

        
        [self rowShouldBeUpdatedAtIndexPath:indexPath];
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


- (void)rowShouldBeUpdatedAtIndexPath:(NSIndexPath*)indexPath {
    [self.insertedRowIndexPaths removeObject:indexPath];
    [self.deletedRowIndexPaths removeObject:indexPath];
    if ([self.updatedRowIndexPaths containsObject:indexPath]) {
        return;
    }
    [self.updatedRowIndexPaths addObject:indexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSInteger totalChanges = [self.deletedSectionIndexes count] +
    [self.insertedSectionIndexes count] +
    [self.deletedRowIndexPaths count] +
    [self.insertedRowIndexPaths count] +
    [self.updatedRowIndexPaths count];
    
    if (totalChanges > 60) {
        
        [self.tableView reloadData];
        return;
    }
    
    if (totalChanges == 0) {
        return;
    }
    
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    
    [self.tableView deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];

    
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *managedObjectContext = [notification object];
    if (managedObjectContext != self.fetchedResultsController.managedObjectContext &&
        managedObjectContext == self.fetchedResultsController.managedObjectContext.parentContext) {
        BOOL isPost = NO;
        
        for(NSManagedObject *object in [[notification userInfo] objectForKey:NSInsertedObjectsKey]) {
            if ([object isKindOfClass:[KGPost class]]) {
                isPost = YES;
                [[self.fetchedResultsController.managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
        }
        
        for(NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
            if ([object isKindOfClass:[KGPost class]]) {
                isPost = YES;
                [[self.fetchedResultsController.managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
        }
        if (isPost) {
            [self.fetchedResultsController.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }
           
        
    }
}



@end
