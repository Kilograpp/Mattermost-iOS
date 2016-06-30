//
//  KGLoginBaseViewController.h
//  Mattermost
//
//  Created by Tatiana on 08/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"

@interface KGLoginBaseViewController : KGViewController <UITextFieldDelegate>
- (void)highlightTextFieldsForError;
@end
