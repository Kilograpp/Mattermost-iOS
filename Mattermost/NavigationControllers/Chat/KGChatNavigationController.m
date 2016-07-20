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

#import "KGNavigationBarTitleView.h"

@interface KGChatNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) KGNavigationBarTitleView *kg_titleView;
@property (nonatomic, strong) UILabel *kg_titleLabel;
@property (nonatomic, strong) UILabel *kg_subtitleLabel;
@property (nonatomic, strong) UIView *activityIndicatorView;
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

- (void)setupTitleLabel {
    self.kg_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 4.f, KGScreenWidth() * 0.6f, 22.f)];
    self.kg_titleLabel.font = [UIFont kg_navigationBarTitleFont];
    self.kg_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.kg_titleLabel.textColor = [UIColor kg_blackColor];
}

- (void)setupNavigationBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor kg_navigationBarTintColor];
    
    [self setupTitleLabel];
    [self setupTitleView];
    [self setupGestureRecognizer];
}

- (void)setupTitleView {
    self.kg_titleView = [[KGNavigationBarTitleView alloc] init];
    self.kg_titleView.frame = CGRectMake(0.f, 0.f, KGScreenWidth() * 0.6f, 44.f);
    [self.navigationBar.topItem setTitleView:self.kg_titleView];
}

- (void)setupGestureRecognizer {
    [self.kg_titleView.titleLabel setUserInteractionEnabled:YES];
    [self.kg_titleView.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMembers)]];
}

- (void)configureTitleViewWithChannel:(KGChannel *)channel
                    loadingInProgress:(BOOL)loadingInProgress {
    [self.kg_titleView configureWithChannel:channel loadingInProgress:loadingInProgress];
}

- (void)showMembers {
    [self.kg_delegate didSelectTitleView];
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
