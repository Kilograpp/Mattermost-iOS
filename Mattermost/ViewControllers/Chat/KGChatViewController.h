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

@property NSMutableIndexSet *deletedSections, *insertedSections;

- (void)configureCell:(KGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
