//
//  KGProfilViewController.m
//  Mattermost
//
//  Created by Mariya on 11.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//



#import "KGProfilViewController.h"
#import "KGBusinessLogic+Session.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"
#import "KGProfileCell.h"
#import "KGProfileDataSource.h"
#import "KGProfileTableHeader.h"
#import "UIStatusBar+SharedBar.h"

@interface KGProfilViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSArray *dataSourceFirstSection;
@property (nonatomic, strong) NSArray *dataSourceSecondSection;
@end

@implementation KGProfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setupNavigationBar];
    [self setupTable];
    [self setupDataSource];
}

#pragma mark - Setup 

- (void)setupNavigationBar{
    self.title = @"Профиль";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close_icon"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(backAction)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setupTable {
    self.tableView.backgroundColor = [UIColor kg_lightLightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[KGProfileCell nib] forCellReuseIdentifier:[KGProfileCell reuseIdentifier]];
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    KGProfileTableHeader *header = [[KGProfileTableHeader alloc] init];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [header configureWithObject:user];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, [KGProfileTableHeader height])];
//    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    view.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = view;
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
////    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [view addSubview:imgView];
//    imgView.backgroundColor = [UIColor blueColor];
//    imgView.center = view.center;
    
        self.tableView.tableHeaderView = header;
//    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), [KGProfileTableHeader height]);
    [header configureWithObject:[[KGBusinessLogic sharedInstance]currentUser]];
}

- (void)setup {
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    NSLog(@"%@",user);
    //
    self.nameLabel.text = user.nickname;
    self.nameLabel.font = [UIFont kg_semibold30Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    //self.avatarView.layer.cornerRadius = 17.5;
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.layer.drawsAsynchronously = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void) backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

#pragma mark - UITableViewDataSource
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 4 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KGProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[KGProfileCell reuseIdentifier] ];
    if (indexPath.section == 0){
        [cell configureWithObject:self.dataSourceFirstSection[indexPath.row]];
    } else {
        [cell configureWithObject:self.dataSourceSecondSection[indexPath.row]];
    }
    //KGChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //[cell configureWithObject:nil];
    return cell;
}


#pragma mark - Private

- (void)setupDataSource {
    NSMutableArray *rightMenuDataSource = [[NSMutableArray alloc] init];
//    __weak typeof(self) wSelf = self;
    KGUser *user = [[KGBusinessLogic sharedInstance]currentUser];
    [rightMenuDataSource addObject:[KGProfileDataSource entryWithTitle:@"Name"
                                                                     iconName:@"profile_name_icon"
                                                                  info:user.firstName
                                                                      handler:^{
//                                                                          [wSelf.delegate navigationToProfile];
                                                                          
                                                                      }]];
    [rightMenuDataSource addObject:[KGProfileDataSource entryWithTitle:@"Username"
                                                              iconName:@"profile_usename_icon"
                                                                  info:user.nickname
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    [rightMenuDataSource addObject:[KGProfileDataSource entryWithTitle:@"Nickname"
                                                              iconName:@"profile_nick_icon"
                                                                  info:user.nickname
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    [rightMenuDataSource addObject:[KGProfileDataSource entryWithTitle:@"Profile photo"
                                                              iconName:@"profile_photo_icon"
                                                                  info:nil
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    
    
    self.dataSourceFirstSection = rightMenuDataSource.copy;
    
    NSMutableArray *secondDataSource = [[NSMutableArray alloc] init];
    [secondDataSource addObject:[KGProfileDataSource entryWithTitle:@"Email"
                                                              iconName:@"profile_email_icon"
                                                                  info:user.email
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    [secondDataSource addObject:[KGProfileDataSource entryWithTitle:@"Change password"
                                                              iconName:@"profile_pass_icon"
                                                                  info:nil
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    [secondDataSource addObject:[KGProfileDataSource entryWithTitle:@"Notification"
                                                              iconName:@"profile_notification_icon"
                                                                  info:@"On"
                                                               handler:^{
                                                                   //                                                                          [wSelf.delegate navigationToProfile];
                                                                   
                                                               }]];
    
    
    self.dataSourceSecondSection = secondDataSource.copy;
}

@end
