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


-(void)setupMessageLabelWithWidth:(CGFloat)screenWidth {
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake((kImageMarginGorizontal + kImageWidth + kImageMarginGorizontal),
                                                                 kImageMarginVertical + kImageHeight/4,
                                                                 (screenWidth - kImageMarginGorizontal - kImageWidth - kImageMarginGorizontal - kLabelMarginTralling),
                                                                 kLabelHeight)];
    self.messageLabel.font = [UIFont kg_regular13Font];
    self.messageLabel.textColor = [UIColor kg_blackColor];
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
    [self setupGradientForViewForTopColor:[UIColor kg_topYellowColorForAlert] toBottomColor:[UIColor kg_bottomYellowColorForAlert]];
    self.imageType.image = [UIImage imageNamed:@"warning_alert"];
}

- (void)configureTypeError {
    [self setupGradientForViewForTopColor:[UIColor kg_topRedColorForAlert] toBottomColor:[UIColor kg_bottomRedColorForAlert]];
    self.imageType.image = [UIImage imageNamed:@"error_alert"];
    
}

- (void)configureTypeSuccess {
    [self setupGradientForViewForTopColor:[UIColor kg_topGreenColorForAlert] toBottomColor:[UIColor kg_bottomGreenColorForAlert]];
     self.imageType.image = [UIImage imageNamed:@"success_alert"];
}

- (void)setupGradientForViewForTopColor:(UIColor *)topColor toBottomColor:(UIColor *)bottomColor {
    CAGradientLayer *bgLayer = [CAGradientLayer setupGradientForTopColor:topColor ToBottomColor:bottomColor];
    bgLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [bgLayer animateLayerInfinitely:bgLayer];
    [self.layer insertSublayer:bgLayer above:0];
    [self bringSubviewToFront:self.messageLabel];
    [self bringSubviewToFront:self.imageType];

}

- (void)showAnimationAlertView{
    [UIView animateWithDuration:0.35
                          delay:0.00
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
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
                            if (self.callback) {
                                [self callback];
                            }
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
