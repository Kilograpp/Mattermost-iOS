//
//  KGAlertView.h
//  Mattermost
//
//  Created by Mariya on 21.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KGAlertTypeWarning = 0,
    KGAlertTypeError,
    KGAlertTypeSuccess
} KGAlertType;

@interface KGAlertView : UIView

@property (copy, nonatomic) void(^callback)();
@property (assign) BOOL enableTapToDismiss;//default YES
@property (nonatomic, strong) UIViewController *presentingViewController;

- (instancetype)initWithType:(KGAlertType)type
                     message:(NSString *)message
                    duration:(NSTimeInterval)duration
                    callback:(void (^)())callback;

- (void)showAlertViewAnimated:(BOOL)animated;
- (void)hideAlertViewAnimated:(BOOL)animated;
//- (void)hideAlertViewAnimated:(BOOL)animated completion:(void (^)())callback;

@end
