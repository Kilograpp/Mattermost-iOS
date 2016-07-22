//
//  KGErrorAction.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGErrorAction.h"
#import "KGAlertManager.h"

@implementation KGErrorAction

- (void)execute {
    [[KGAlertManager sharedManager] showErrorWithMessage:self.message];
}

@end
