//
//  KGMessagePresenter.h
//  Mattermost
//
//  Created by Igor Vedeneev on 16.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGPost;

@interface KGMessagePresenter : NSObject
- (void)presentNotificationWithMessage:(KGPost *)post;
@end
