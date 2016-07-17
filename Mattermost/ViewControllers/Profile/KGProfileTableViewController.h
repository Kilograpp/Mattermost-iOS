//
//  KGProfileTableViewController.h
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGProfileTableViewController : UITableViewController
@property (nonnull, nonatomic, strong) NSString *userId;
@property (nonnull, nonatomic, strong) UIViewController *previousControler;
@end
