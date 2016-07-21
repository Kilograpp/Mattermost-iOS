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
#import "UIStatusBar+SharedBar.h"
#import "KGChatNavigationController.h"
#import "UIImage+Resize.h"
#import "KGRightMenuViewController.h"
#import <MFSideMenu/MFSideMenu.h>

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
@property (assign) BOOL isFirstLoad;
@property (assign) BOOL isCurrentUser;
@property (nonatomic, strong) KGUser *user;
@end

@implementation KGProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFirstLoad = YES;
    [self setup];
}

- (void)setupNavigationBar {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close_icon"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backAction)];
    backButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backButton;

}
//
- (void)backAction {
    if (self.previousControler) {
        [self presentViewController:self.previousControler animated:YES completion:nil];
    } else {
    [[UIStatusBar sharedStatusBar] moveToPreviousView];
    
    [self dismissViewControllerAnimated:YES completion:^ {
        NSLog(@"yes");
        [[UIStatusBar sharedStatusBar] moveToPreviousView];
    }];
    }
}

- (void)setup {
    self.user = [KGUser managedObjectById:self.userId];
    if ([self.userId isEqual:[KGBusinessLogic sharedInstance].currentUserId]) {
        self.isCurrentUser = YES;
    }
//    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    self.nameTitleLabel.font = [UIFont kg_semibold30Font];
    self.nameTitleLabel.textColor = [UIColor kg_blackColor];
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.nameTitleLabel.text = self.user.nickname;
    
    NSString* smallAvatarKey = [self.user.imageUrl.absoluteString stringByAppendingString:@"_feed"];
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:smallAvatarKey]) {
        UIImage *smallAvatar = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:smallAvatarKey];
        self.avatarImageView.image = smallAvatar;
    } else {
        [self.avatarImageView setImageWithURL:self.user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return CGFLOAT_MIN;
    } else {
        return 30.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isCurrentUser) {
            return 4;
        } else {
            return 3;
        }
    } else {
        if (self.isCurrentUser) {
            return 3;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (self.isCurrentUser) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = self.user.firstName;
                cell.imageView.image = [UIImage imageNamed:@"profile_name_icon"];
                break;
            case 1:
                cell.textLabel.text = @"Username";
                cell.detailTextLabel.text = self.user.nickname;
                cell.imageView.image = [UIImage imageNamed:@"profile_usename_icon"];
                break;
            case 2:
                cell.textLabel.text = @"Nickname";
                cell.detailTextLabel.text = self.user.nickname;
                cell.imageView.image = [UIImage imageNamed:@"profile_nick_icon"];
                break;
            case 3:
                cell.textLabel.text = @"Profile photo";
                cell.imageView.image = [UIImage imageNamed:@"profile_photo_icon"];
                break;
            default:
                break;
        }
        
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text = self.user.email;
                cell.imageView.image = [UIImage imageNamed:@"profile_email_icon"];
                break;
            case 1:
                cell.textLabel.text = @"Change password";
                cell.imageView.image = [UIImage imageNamed:@"profile_pass_icon"];
                break;
            case 2:
                cell.textLabel.text = @"Notification";
                cell.detailTextLabel.text = @"On";
                cell.imageView.image = [UIImage imageNamed:@"profile_notification_icon"];
                break;
            default:
                break;
        }
    }
    return cell;
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
                if ([self.userId isEqual:[KGBusinessLogic sharedInstance].currentUserId]){
                    [self changeProfilePhoto];
                }
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
    [UIAlertAction actionWithTitle:NSLocalizedString(@"Take from library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
    
    
    if (self.updatedAvatarImage) {
        self.avatarImageView.image = self.updatedAvatarImage;
        [[KGAlertManager sharedManager] showProgressHud];
        [[KGBusinessLogic sharedInstance] updateImageForCurrentUser:self.updatedAvatarImage withCompletion:^(KGError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [[KGAlertManager sharedManager] hideHud];

//
                NSURL* avatarUrl = self.user.imageUrl;
                NSString* smallAvatarKey = [avatarUrl.absoluteString stringByAppendingString:@"_feed"];
                UIImage *imageToCathe = self.updatedAvatarImage;
                UIImage *roundedImage = KGRoundedImage(imageToCathe, CGSizeMake(40, 40));
                [[SDImageCache sharedImageCache] storeImage:roundedImage forKey:smallAvatarKey];
                
                KGRightMenuViewController *vc = (KGRightMenuViewController *)self.menuContainerViewController.rightMenuViewController;
                [vc updateAvatarImage];
            });
        }];
        
 
    }
}


@end
