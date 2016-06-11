//
//  RightMenu.h
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"

@protocol KGRightMenuDelegate <NSObject>

@end

@interface KGRightMenuViewController : KGViewController
@property (nonatomic, weak) id<KGRightMenuDelegate> delegate;
@end
