//
//  KGViewController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGError.h"

@interface KGViewController : UIViewController
- (void)processError:(KGError *)error;
@end
