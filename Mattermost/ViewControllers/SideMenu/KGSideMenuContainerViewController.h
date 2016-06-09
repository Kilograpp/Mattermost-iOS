//
//  KGSideMenuContainerViewController.h
//  Envolved
//
//  Created by Dmitry Arbuzov on 19/01/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "MFSideMenuContainerViewController.h"

extern float const KGLeftMenuOffset;

@interface KGSideMenuContainerViewController : MFSideMenuContainerViewController

+ (instancetype)containerWithCenterViewController:(id)centerViewController
                           leftMenuViewController:(id)leftMenuViewController
                          rightMenuViewController:(id)rightMenuViewController;

+ (instancetype)configuredContainerViewController;

@end
