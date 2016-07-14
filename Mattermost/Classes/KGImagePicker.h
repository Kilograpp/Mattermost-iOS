//
//  KGImagePicker.h
//  Mattermost
//
//  Created by Maxim Gubin on 13/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

@import UIKit;

@interface KGImagePicker : NSObject

- (void)launchPickerFromController:(UIViewController*)controller
              didHidePickerHandler:(void (^)(void))didHidePickerHandler
           willBeginPickingHandler:(void (^)(void))willBeginPickingHandler
               didPickImageHandler:(void (^)(UIImage *image))didPickImageHandler
           didFinishPickingHandler:(void (^)(BOOL isCancelled))didFinishPickingHandler;


@end
