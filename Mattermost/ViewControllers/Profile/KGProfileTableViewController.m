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

@interface KGProfileTableViewController ()
//FIXME: код стайл и названия
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;

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
    KGUser *user = [KGUser managedObjectById:self.userId];
    self.nameLabel.font = [UIFont kg_semibold30Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = user.nickname;
    [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.name.text = user.firstName;
    self.username.text = user.nickname;
    self.nickname.text = user.nickname;
    self.email.text = user.email;
}

@end
