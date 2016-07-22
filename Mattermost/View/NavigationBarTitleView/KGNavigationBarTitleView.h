//
//  KGNavigationBarTitleView.h
//  Mattermost
//
//  Created by Igor Vedeneev on 14.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KGChannel;

@interface KGNavigationBarTitleView : UIView

@property (nonatomic, strong) UIView *statusIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *disclosureView;

- (void)configureWithChannel:(KGChannel *)channel
           loadingInProgress:(BOOL)loadingInProgress;

@end
