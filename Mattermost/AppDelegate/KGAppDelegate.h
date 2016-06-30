//
//  KGAppDelegate.h
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGSideMenuContainerViewController;

@interface KGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, readonly) KGSideMenuContainerViewController* menuContainerViewController;
@property (strong, nonatomic) UIWindow *window;

- (void)loadInitialScreen;

@end

