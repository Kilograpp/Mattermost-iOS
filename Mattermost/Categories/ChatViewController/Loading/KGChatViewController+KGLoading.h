//
//  KGChatViewController+KGLoading.h
//  Mattermost
//
//  Created by Igor Vedeneev on 13.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatViewController.h"

@interface KGChatViewController (KGLoading)
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *noMessadgesLabel;
@end
