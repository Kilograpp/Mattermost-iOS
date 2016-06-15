//
//  KGTextField.h
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@interface KGTextField : JVFloatLabeledTextField
@property (nonatomic,strong) UIView * underlineView;

- (void)highlightForError;
@end
