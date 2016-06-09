//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "NSManagedObject+CustomFinder.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObjectContext+MagicalThreading.h"
#import "NSManagedObject+MagicalRecord.h"


@implementation NSManagedObject (CustomFinder)

+ (NSFetchedResultsController *) MR_fetchController:(NSFetchRequest *)request
                                           delegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                          groupedBy:(NSString *)groupKeyPath {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSFetchedResultsController *controller = [self MR_fetchController:request
                                                             delegate:delegate
                                                         useFileCache:NO
                                                            groupedBy:groupKeyPath
                                                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [self MR_performFetch:controller];

    return controller;
#pragma clang diagnostic pop
}


@end