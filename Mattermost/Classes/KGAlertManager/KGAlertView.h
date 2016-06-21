//
//  KGAlertView.h
//  Mattermost
//
//  Created by Mariya on 21.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGAlertView : UIView

typedef enum {
    KGMessageTypeWarning = 0,
    KGMessageTypeError,
    KGMessageTypeSuccess
} KGMessageType;

+ (instancetype)sharedMessage;
- (void)showAlertViewWithMessage:(NSString *)message
                        withType:(KGMessageType)type
                    withDuration:(NSTimeInterval)duration
                    withCallback:(void (^)())callback;

@property (copy, nonatomic) void(^callback)();
@end
