//
//  KGImagePicker.m
//  Mattermost
//
//  Created by Maxim Gubin on 13/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImagePicker.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "KGImagePickerController.h"
#import "KGAlertManager.h"
#import "KGUtils.h"
#import "KGAlertManager.h"

@interface KGImagePicker () <CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) void (^didPickImageHandler)(UIImage *image);
@property (nonatomic, strong) void (^didHidePickerHandler)(void);
@property (nonatomic, strong) void (^willBeginPickingHandler)(void);
@property (nonatomic, strong) void (^didFinishPickingHandler)(BOOL isCancelled);
@property (nonatomic, strong) UIViewController* controller;

@end

@implementation KGImagePicker

- (void)launchPickerFromController:(UIViewController*)controller
              didHidePickerHandler:(void (^)(void))didHidePickerHandler
           willBeginPickingHandler:(void (^)(void))willBeginPickingHandler
               didPickImageHandler:(void (^)(UIImage *image))didPickImageHandler
           didFinishPickingHandler:(void (^)(BOOL isCancelled))didFinishPickingHandler{
    self.controller = controller;
    self.didPickImageHandler = didPickImageHandler;
    self.didHidePickerHandler = didHidePickerHandler;
    self.willBeginPickingHandler = willBeginPickingHandler;
    self.didFinishPickingHandler = didFinishPickingHandler;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCameraAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.controller presentViewController:picker animated:YES completion:nil];
            });
        }];
    }];
    
    UIAlertAction *openGalleryAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take from library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                picker.delegate = self;
                [picker setShowsNumberOfAssets:YES];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                
                [self.controller presentViewController:picker animated:YES completion:nil];
            });
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        safetyCall(self.didHidePickerHandler);
        safetyCall(self.didFinishPickingHandler, YES);
    }];
    [alertController addAction:openCameraAction];
    [alertController addAction:openGalleryAction];
    [alertController addAction:cancelAction];
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

- (void)presentPickerControllerWithType:(UIImagePickerControllerSourceType)type {
    KGImagePickerController *pickerController = [[KGImagePickerController alloc] init];
    pickerController.sourceType = type;
    pickerController.delegate = self;
    [self.controller presentViewController:pickerController animated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;

    [self.controller dismissViewControllerAnimated:YES completion:^{
        safetyCall(self.didHidePickerHandler);
    }];
    
    safetyCall(self.willBeginPickingHandler);
    for (PHAsset *asset in assets) {
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeAspectFill
                              options:options
                        resultHandler:^(UIImage *image, NSDictionary *info) {
                            safetyCall(self.didPickImageHandler, image);
                        }];
    }
    
    safetyCall(self.didFinishPickingHandler, NO);

}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    [self.controller dismissViewControllerAnimated:YES completion:^{
        safetyCall(self.didHidePickerHandler);
        safetyCall(self.didFinishPickingHandler, YES);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.controller dismissViewControllerAnimated:YES completion:^{
        safetyCall(self.didHidePickerHandler);
    }];

    safetyCall(self.willBeginPickingHandler);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    safetyCall(self.didPickImageHandler, image);
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    safetyCall(self.didFinishPickingHandler, NO);
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    if (picker.selectedAssets.count < 5){
        return YES;
    } else {
        [[KGAlertManager sharedManager] showWarningWithMessage:@"Uploads limited to 5 files maximum. Please use additional posts for more files."];
        return NO;
    }
    
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(PHAsset *)asset {
    [[KGAlertManager sharedManager] hideWarning];
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.controller dismissViewControllerAnimated:YES completion:^{
        safetyCall(self.didHidePickerHandler);
        safetyCall(self.didFinishPickingHandler, YES);
    }];
}


@end
