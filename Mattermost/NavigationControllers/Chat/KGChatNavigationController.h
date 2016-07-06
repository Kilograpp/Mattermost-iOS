//
//  KGChatNavigationController.h
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGNavigationController.h"

@interface KGChatNavigationController : KGNavigationController
@property (nonatomic, copy) NSString *kg_title;
@property (nonatomic, copy) NSString *kg_subtitle;

- (void)setupTitleViewWithUserName:(NSString *)userName
                          subtitle:(NSString *)subtitle
                   shouldHighlight:(BOOL)shouldHighlight
                 loadingInProgress:(BOOL)loadingInProgress
                      errorOccured:(BOOL)errorOccured;
@end
