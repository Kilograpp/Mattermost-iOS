//
//  KGLoginBaseViewController.m
//  Mattermost
//
//  Created by Tatiana on 08/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGLoginBaseViewController.h"
#import "KGTextField.h"
#import "UIColor+KGPreparedColor.h"
@interface KGLoginBaseViewController () 

@end

@implementation KGLoginBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)highlightTextFieldsForError {
    for (UIView *v in self.view.subviews){
        if ([v isKindOfClass:[KGTextField class]]) {
            KGTextField *textField = (KGTextField *)v;
            textField.underlineView.backgroundColor = [UIColor kg_redColor];
        }
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[KGTextField class]]){
        KGTextField *customTextField = (KGTextField *)textField;
        customTextField.underlineView.backgroundColor = [UIColor kg_blueColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[KGTextField class]]) {
        KGTextField *customTextField = (KGTextField *)textField;
        customTextField.underlineView.backgroundColor = [UIColor kg_lightGrayColor];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[KGTextField class]]) {
        for (UIView *v in self.view.subviews){
            if ([v isKindOfClass:[KGTextField class]]) {
                KGTextField *textField = (KGTextField *)v;
                textField.underlineView.backgroundColor = [UIColor kg_lightGrayColor];
            }
        }
        KGTextField *customTextField = (KGTextField *)textField;
        customTextField.underlineView.backgroundColor = [UIColor kg_blueColor];
        
    }
    return YES;
}
@end
