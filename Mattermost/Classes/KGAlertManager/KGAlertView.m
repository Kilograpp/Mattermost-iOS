//
//  KGAlertView.m
//  Mattermost
//
//  Created by Mariya on 21.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAlertView.h"
#import "UIFont+KGPreparedFont.h"
#import "CAGradientLayer+KGPreparedGradient.h"
#import "UIColor+KGPreparedColor.h"

static KGAlertView *sharedMessages;
static CGFloat const kAlertViewHeight = 70;
static CGFloat const kImageHeight = 30;
static CGFloat const kImageWidth = 20;
static CGFloat const kImageMarginGorizontal = 10;
static CGFloat const kImageMarginVertical = 20;
static CGFloat const kLabelMarginTralling = 10;
static CGFloat const kLabelHeight = 20;


@interface KGAlertView ()
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageType;
@end

@implementation KGAlertView

- (void) setupAlertView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.frame = CGRectMake(0, -kAlertViewHeight, screenWidth, kAlertViewHeight);
    [self setupImageType];
    [self setupMessageLabelWithWidth:screenWidth];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

- (void)setupImageType {
    self.imageType = [[UIImageView alloc]initWithFrame:CGRectMake(kImageMarginGorizontal, kImageMarginVertical, kImageWidth, kImageHeight)];
    self.imageType.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageType];
}


- (void)setupMessageLabelWithWidth:(CGFloat)screenWidth {
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake((kImageMarginGorizontal + kImageWidth + kImageMarginGorizontal),
                                                                 kImageMarginVertical + kImageHeight/4,
                                                                 (screenWidth - kImageMarginGorizontal - kImageWidth - kImageMarginGorizontal - kLabelMarginTralling),
                                                                 kLabelHeight)];
    self.messageLabel.font = [UIFont kg_boldText13Font];
    self.messageLabel.textColor = [UIColor kg_whiteColor];
    [self addSubview:self.messageLabel];
}


+ (KGAlertView *)sharedMessage{
    if (!sharedMessages){
        sharedMessages = [[[self class] alloc] init];
    }
    return sharedMessages;
}

- (void)configureAlertViewType:(KGMessageType)messageType {
    
    switch (messageType) {
        case KGMessageTypeWarning:
            [self configureTypeWarning];
            break;
        case KGMessageTypeError:
            [self configureTypeError];
            break;
        case KGMessageTypeSuccess:
            [self configureTypeSuccess];
            break;
    }
}

- (void)configureTypeWarning {
    [self setupColorForView :[UIColor kg_yellowColorForAlert]];
    self.imageType.image = [UIImage imageNamed:@"warning_alert"];
}

- (void)configureTypeError {
    [self setupColorForView :[UIColor kg_redColorForAlert]];
    self.imageType.image = [UIImage imageNamed:@"error_alert"];
    
}

- (void)configureTypeSuccess {
    [self setupColorForView :[UIColor kg_greenColorForAlert]];
     self.imageType.image = [UIImage imageNamed:@"success_alert"];
}

- (void)setupColorForView:(UIColor *)color {
    self.backgroundColor = color;
}

- (void)showAnimationAlertView{
    [UIView animateWithDuration:0.35
                          delay:0.00
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelStatusBar + 1;
        CGRect frameNew = self.frame;
        frameNew.origin.y = frameNew.origin.y + kAlertViewHeight;
        self.frame = frameNew;
                            
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hideAnimationAlertView {
    [UIView animateWithDuration:0.35
                          delay:0.00
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            CGRect frameNew = self.frame;
                            frameNew.origin.y = frameNew.origin.y - kAlertViewHeight;
                            self.frame = frameNew;
                            
                        } completion:^(BOOL finished) {
                            [[[UIApplication sharedApplication] delegate] window].windowLevel = UIWindowLevelNormal;
                            if (self.callback) {
                                [self callback];
                            }
                            [self.messageLabel removeFromSuperview];
                            [self.imageType removeFromSuperview];
                        }];
}

- (void)showAlertViewWithMessage:(NSString *)message
                                withType:(KGMessageType)type
                            withDuration:(NSTimeInterval)duration
                            withCallback:(void (^)())callback {
    [self setupAlertView];
    self.callback = callback;
    [self.messageLabel setText:message];
    [self configureAlertViewType:type];
    [self showAnimationAlertView];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self hideAnimationAlertView];
        
    });

}



@end
