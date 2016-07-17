//
//  KGAlertView.m
//  Mattermost
//
//  Created by Mariya on 21.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAlertView.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "NSString+HeightCalculation.h"
#import "KGUIUtils.h"
#import <Masonry/Masonry.h>

static KGAlertView *sharedMessages;

@interface KGAlertView ()
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

@end

@implementation KGAlertView

#pragma mark - Init

- (instancetype)initWithType:(KGAlertType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration
                    callback:(void (^)())callback {
    if (self = [super init]) {
        [self setMessage:message];
        [self setDuration:duration];
        [self setupFrame];
        [self setupMessageLabel];
        [self setupIconImageView];
        [self setupBackgroundViewWithAlertType:type];
        [self setupMessageLabel];
        [self setEnableTapToDismiss:YES];
        [self setupTapGestureRecognizer];
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupFrame {
    self.frame = CGRectMake(0, -[self heightWithMessage], KGScreenWidth(), [self heightWithMessage]);
}

- (void)setupBackgroundViewWithAlertType:(KGAlertType)type {
    UIColor *backgroundColor;
    NSString *iconImageName;
    switch (type) {
        case KGAlertTypeError: {
            backgroundColor = [UIColor kg_redColorForAlert];
            iconImageName = @"error_alert";
            break;
        }
            
        case KGAlertTypeWarning: {
            backgroundColor = [UIColor kg_yellowColorForAlert];
            iconImageName = @"warning_alert";
            break;
        }
            
        case KGAlertTypeSuccess: {
            backgroundColor = [UIColor kg_greenColorForAlert];
            iconImageName = @"success_alert";
            break;
        }
            
        default:
            break;
    }
    
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
    self.backgroundColor = backgroundColor;
}

- (void)setupTapGestureRecognizer {
    if (self.enableTapToDismiss) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissAction)];
        [self addGestureRecognizer:self.tapGestureRecognizer];
    }
}

- (void)addToSuperview {
//    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self.presentingViewController.view addSubview:self];
}

- (void)setupIconImageView {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.messageLabel.mas_leading).offset(-8);
        make.centerY.equalTo(self.messageLabel);
        make.height.width.equalTo(@25);
    }];
}


- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.font = [UIFont kg_boldText13Font];
    self.messageLabel.textColor = [UIColor kg_whiteColor];
    self.messageLabel.text = self.message;
    self.messageLabel.numberOfLines = 0;
    [self addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(53);
        make.top.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-8);
    }];
}


#pragma mark - Public

- (void)showAlertViewAnimated:(BOOL)animated {
    [self addToSuperview];
    [UIView animateWithDuration:animated ? 0.35 : 0
                          delay:0.00
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
//                         [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelStatusBar + 1;
                         
        CGRect frameNew = self.frame;
        frameNew.origin.y = frameNew.origin.y + [self heightWithMessage];
        self.frame = frameNew;
                            
    } completion:^(BOOL finished) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.duration * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self hideAlertViewAnimated:YES];

        });
    }];
}

- (void)hideAlertViewAnimated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.35 : 0
                          delay:0.00
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect frameNew = self.frame;
                         frameNew.origin.y = frameNew.origin.y - [self heightWithMessage];
                         self.frame = frameNew;
                         
                     } completion:^(BOOL finished) {
//                          [self removeFromSuperview];
//                        [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelNormal;
                         if (self.callback) {
                             [self callback];
                         }
                     }];
}


#pragma mark - Private

- (CGFloat)heightWithMessage {
    CGFloat messageLabelHeight = [self.message kg_heightForTextWidth:KGScreenWidth() - 70 font:[UIFont kg_boldText13Font]];
    return MAX(messageLabelHeight + 40, 70);
}


#pragma mark - Actions

- (void)tapDismissAction {
    [self hideAlertViewAnimated:YES];
}


#pragma mark - Private Getters

- (BOOL)isPresenting {
    return self.superview ? YES : NO;
}

@end
