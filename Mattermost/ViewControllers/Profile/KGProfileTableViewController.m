//
//  KGProfileTableViewController.m
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGProfileTableViewController.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"
#import "KGBusinessLogic+Session.h"
#import "KGAlertManager.h"
#import "UIImage+KGRotate.h"
#import "KGImagePickerController.h"

@import AVFoundation;
@import Photos;


@interface KGProfileTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//FIXME: код стайл и названия
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIImage *updatedAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *email;

@end

@implementation KGProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupNavigationBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)setupNavigationBar {
    self.title = @"Профиль";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close_icon"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backAction)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setup {
//    KGUser *user = [KGUser managedObjectById:self.userId];
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    self.nameTitleLabel.font = [UIFont kg_semibold30Font];
    self.nameTitleLabel.textColor = [UIColor kg_blackColor];
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.nameTitleLabel.text = user.nickname;
    [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.name.text = user.firstName;
    self.username.text = user.nickname;
    self.nickname.text = user.nickname;
    self.email.text = user.email;
    //self.headerView.backgroundColor = [UIColor kg_lightLightGrayColor];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return CGFLOAT_MIN;
    } else {
        return 30.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            case 3:
                [self changeProfilePhoto];
                break;
            default:
                break;
        }
        
    } else {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changeProfilePhoto {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCameraAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
                //                [[KGAlertManager sharedManager] showErrorWithTitle:@"Нет доступа к камере"
                //                                                           message:@"Пожалуйста разрешите использовать камеру в настройках"];
                [[KGAlertManager sharedManager]showErrorWithMessage:@"Нет доступа к камере. /nПожалуйста разрешите использовать камеру в настройках"];
                break;
                
            default:
                [self presentPickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
                break;
        }
    }];
    
    UIAlertAction *openGalleryAction =
    [UIAlertAction actionWithTitle:NSLocalizedString(@"From library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        switch ([PHPhotoLibrary authorizationStatus]) {
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
                //                [[KGAlertManager sharedManager] showErrorWithTitle:@"Нет доступа к фотографиям"
                //                                                           message:@"Пожалуйста разрешите использовать фотографии в настройках"];
                [[KGAlertManager sharedManager]showErrorWithMessage:@"Нет доступа к фотографиям. /nПожалуйста разрешите использовать фотографии в настройках"];
                break;
                
            default: {
                [self presentPickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            }
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:openCameraAction];
    [alertController addAction:openGalleryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}

- (void)presentPickerControllerWithType:(UIImagePickerControllerSourceType)type {
    KGImagePickerController *pickerController = [[KGImagePickerController alloc] init];
    pickerController.sourceType = type;
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    self.updatedAvatarImage = [image kg_normalizedImage];
    if (self.updatedAvatarImage){
        self.avatarImageView.image = self.updatedAvatarImage;
        [[KGBusinessLogic sharedInstance] updateImageForCurrentUser:self.updatedAvatarImage withCompletion:nil];
        [[SDImageCache sharedImageCache] storeImage:self.updatedAvatarImage forKey:[[KGBusinessLogic sharedInstance] currentUser].imageUrl.absoluteString];
 
    }
    //[self.tableHeaderView reloadWithImage:self.updatedAvatarImage];
}


@end
