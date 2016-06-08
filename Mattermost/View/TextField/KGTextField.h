//
//  KGTextField.h
//  Mattermost
//
//  Created by Tatiana on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGTextField : UITextField
@property (nonatomic,strong) UIView * underlineView;

- (void)highlightForError;
@end
