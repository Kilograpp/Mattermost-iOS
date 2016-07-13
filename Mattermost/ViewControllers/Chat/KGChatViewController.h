//
//  KGChatViewController.h
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "SLKTextViewController.h"
@class KGTableViewCell;

@interface KGChatViewController : SLKTextViewController
@property (strong, nonatomic) NSIndexPath* lastPath;
@property NSMutableIndexSet *insertedSectionIndexes, *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableArray* temporaryIgnoredObjects;;
@property NSMutableArray* deletedRowIndexPaths, *insertedRowIndexPaths, * updatedRowIndexPaths;

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
