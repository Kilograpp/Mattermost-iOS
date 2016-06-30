//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData.h>

@interface NSManagedObject (CustomFinder)

+ (NSFetchedResultsController *) MR_fetchController:(NSFetchRequest *)request
                                           delegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                          groupedBy:(NSString *)groupKeyPath;

@end