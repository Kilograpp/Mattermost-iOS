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

@interface KGChatNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *kg_titleLabel;
@property (nonatomic, strong) UILabel *kg_subtitleLabel;
@end

@implementation KGChatNavigationController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - Setup

- (void)setupNavigationBar {
    UINavigationBar *navBar = self.navigationBar;
    navBar.translucent = NO;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.6f, 44.f)];
    self.kg_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 4.f, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.6f, 22.f)];
    self.kg_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 22.f, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.6f, 22.f)];
    
    self.kg_titleLabel.font = [UIFont kg_navigationBarTitleFont];
    self.kg_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.kg_titleLabel.textColor = [UIColor kg_blackColor];

    self.kg_subtitleLabel.font = [UIFont kg_navigationBarSubtitleFont];
    self.kg_subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.kg_subtitleLabel.textColor = [UIColor kg_blueColor];

    
    [titleView addSubview:self.kg_titleLabel];
    [titleView addSubview:self.kg_subtitleLabel];
    [self.navigationBar.topItem setTitleView:titleView];
}

- (void)setupTitleViewWithUserName:(NSString *)userName subtitle:(NSString *)subtitle shouldHighlight:(BOOL)shouldHighlight {
    self.kg_titleLabel.text = userName;
    self.kg_subtitleLabel.text = subtitle;
    self.kg_subtitleLabel.textColor = shouldHighlight ? [UIColor kg_enabledButtonTintColor] : [UIColor kg_disabledButtonTintColor];
}


#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - Orientations

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
//    return UIBarPositionTopAttached;
//}

@end
