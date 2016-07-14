//
//  KGChatNavigationController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 09.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChatNavigationController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUIUtils.h"
#import <DGActivityIndicatorView.h>

@interface KGChatNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *kg_titleLabel;
@property (nonatomic, strong) UILabel *kg_subtitleLabel;
@property (nonatomic, strong) DGActivityIndicatorView *loadingView;
@end

@implementation KGChatNavigationController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - Setup

- (void)setupNavigationBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor kg_navigationBarTintColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KGScreenWidth() * 0.6f, 44.f)];
    self.kg_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 4.f, KGScreenWidth() * 0.6f, 22.f)];
    self.kg_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 22.f, KGScreenWidth() * 0.6f, 22.f)];
    
    self.kg_titleLabel.font = [UIFont kg_navigationBarTitleFont];
    self.kg_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.kg_titleLabel.textColor = [UIColor kg_blackColor];

    self.kg_subtitleLabel.font = [UIFont kg_navigationBarSubtitleFont];
    self.kg_subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.kg_subtitleLabel.textColor = [UIColor kg_blueColor];
    
    self.loadingView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor kg_blueColor] size:25];
    self.loadingView.frame = CGRectMake(0, 0, 25, 20);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.loadingView.center = self.kg_subtitleLabel.center;
    
    [titleView addSubview:self.kg_titleLabel];
    [titleView addSubview:self.kg_subtitleLabel];
    [titleView addSubview:self.loadingView];
    [self.navigationBar.topItem setTitleView:titleView];
}

- (void)setupTitleViewWithUserName:(NSString *)userName
                          subtitle:(NSString *)subtitle
                   shouldHighlight:(BOOL)shouldHighlight
                 loadingInProgress:(BOOL)loadingInProgress
                      errorOccured:(BOOL)errorOccured {
    self.kg_titleLabel.text = userName;
    self.kg_subtitleLabel.text = errorOccured ? NSLocalizedString(@"No connection", nil) : subtitle;
    self.kg_subtitleLabel.textColor = shouldHighlight && !errorOccured ? [UIColor kg_enabledButtonTintColor] : [UIColor kg_disabledButtonTintColor];
    self.kg_subtitleLabel.hidden = loadingInProgress;
    self.loadingView.hidden = !loadingInProgress;
    if (loadingInProgress) {
        [self.loadingView startAnimating];
    } else {
        [self.loadingView stopAnimating];
    }

}


#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
