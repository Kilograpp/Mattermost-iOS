//
//  KGViewController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGError.h"
#import "KGAlertManager.h"

@interface KGViewController : UIViewController

- (void)showProgressHud;
- (void)hideProgressHud;

- (void)processError:(KGError *)error;
- (void)processErrorWithTitle:(NSString *)title message:(NSString *)message;

- (void)test;

@end
