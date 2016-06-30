//
//  KGAutoCompletionCell.h
//  Mattermost
//
//  Created by Mariya on 20.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGAutoCompletionCell : KGTableViewCell

- (void)configureWithObject:(id)object;
+ (CGFloat)heightWithObject:(id)object;

@end
