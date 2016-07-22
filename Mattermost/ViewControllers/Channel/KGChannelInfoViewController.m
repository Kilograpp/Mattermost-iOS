//
//  KGChannelInfoViewController.m
//  Mattermost
//
//  Created by Julia Samoshchenko on 20.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Channel.h"
#import "KGChannelInfoViewController.h"
#import "UIStatusBar+SharedBar.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGChannel.h"
#import "KGTeam.h"

#import "MagicalRecord.h"

#import "KGUserStatus.h"
#import "KGUserStatusObserver.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

#import "KGMembersViewController.h"

static NSString *const kPresentMembersSegueIdentier = @"showMembers";

typedef NS_ENUM(NSInteger, Sections) {
    kSectionTitle = 0,
    kSectionInformation,
    kSectionNotification,
    kSectionMembers,
    kSectionLeave,
    
    kSectionCount
};

typedef NS_ENUM(NSInteger, NumberOfRows) {
    kSectionTitleNumberOfRows = 1,
    kSectionInformationNumberOfRows = 4,
    kSectionNotificationNumberOfRows = 1,
    kSectionMembersMinNumberOfRows = 2,
    kSectionLeaveNumberOfRows = 1,
};

static CGFloat const kTableViewTitleSectionHeaderHeight = 0.1;
static CGFloat const kTableViewMembersSectionHeaderHeight = 40;
static CGFloat const kTableViewOtherSectionsHeaderHeight = 15;
static CGFloat const kTableViewTitleCellHeight = 90;
static CGFloat const kTableViewCellHeight = 50;

static NSInteger const kMaxVisibleNumberOfMembersRows = 5;

static NSString *const kDefaultTableViewCellReuseIdentifier = @"defaultTableViewCellReuseIdentifier";
static NSString *const kUserCellReuseIdentifier = @"userCellReuseIdentifier";
static NSString *const kTitleValueCellReuseIdentifier = @"titleValueCellReuseIdentifier";

@interface KGChannelInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *detailsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) BOOL isAdditionMembers;
@end

@implementation KGChannelInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupTitlesArray];
    [self setupDetailsArray];
    [self setupUsersArray];
    [self setupNavigationBar];
}


#pragma mark - Setup

- (void)setupTitlesArray {
    self.titlesArray = @[@"Header", @"Purpose", @"URL", @"ID"];
}

// TODO self.channel.team -> URL
- (void)setupDetailsArray {
    self.detailsArray = @[self.channel.header, self.channel.purpose, @"kilograpp", self.channel.identifier];
}

- (void)setupUsersArray {
    [[KGBusinessLogic sharedInstance] loadExtraInfoForChannel:self.channel withCompletion:^(KGError *error) {
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
        //        self.users = [KGUser MR_findAllWithPredicate:predicate];
        self.users = self.channel.members.allObjects;
        KGUser *user = self.users.firstObject;
        KGUserStatus *status = [[KGUserStatusObserver sharedObserver] userStatusForIdentifier:user.identifier];
        [self.tableView reloadData];
    }];
}

- (void)setupNavigationBar {
    [[UIStatusBar sharedStatusBar] moveTemporaryToRootView];
}

- (void)setupTitle {
    self.title = @"Channel Info";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kSectionTitle:
            return kSectionTitleNumberOfRows;
        case kSectionInformation:
            return kSectionInformationNumberOfRows;
        case kSectionNotification:
            return kSectionNotificationNumberOfRows;
        case kSectionMembers:
            return (kSectionMembersMinNumberOfRows + MIN([self numberOfMembersInChannel], kMaxVisibleNumberOfMembersRows));
        case kSectionLeave:
            return kSectionLeaveNumberOfRows;
        default:
            return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kSectionTitle: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultTableViewCellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:kDefaultTableViewCellReuseIdentifier];
            }

            cell.textLabel.text = self.channel.name;
            cell.textLabel.textColor = [UIColor kg_blackColor];
            cell.imageView.image = [UIImage imageNamed:@"about_kg_icon"];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            return cell;
        }
            
        case kSectionInformation: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleValueCellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kTitleValueCellReuseIdentifier];
            };
            cell.textLabel.text = self.titlesArray[indexPath.row];
            cell.textLabel.textColor = [UIColor kg_blackColor];
            cell.detailTextLabel.text = self.detailsArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          
            return cell;
        }
            
        case kSectionNotification: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleValueCellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kTitleValueCellReuseIdentifier];
            };

            cell.textLabel.text = @"Notification";
            cell.textLabel.textColor = [UIColor kg_blackColor];
            cell.imageView.image = [UIImage imageNamed:@"profile_notification_icon"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
            
        case kSectionMembers: {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultTableViewCellReuseIdentifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kDefaultTableViewCellReuseIdentifier];
                }
                cell.textLabel.text = @"Add Members";
                cell.textLabel.textColor = [UIColor kg_blueColor];
                
                return cell;
            }
            
            if (indexPath.row == (kSectionMembersMinNumberOfRows + MIN([self numberOfMembersInChannel], kMaxVisibleNumberOfMembersRows) - 1)) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultTableViewCellReuseIdentifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kDefaultTableViewCellReuseIdentifier];
                }

                cell.textLabel.text = @"See all Members";
                cell.imageView.image = nil;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor kg_blueColor];
                
                return cell;
            }
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kUserCellReuseIdentifier];
            }
            
            KGUser *user = self.users [indexPath.row - 1];
            cell.textLabel.text = [self configureUserName:user];
            cell.textLabel.textColor = [UIColor kg_blackColor];
            cell.detailTextLabel.text = [self configureStatus:user];
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.clipsToBounds = YES;
            
            __weak typeof(cell) wCell = cell;
            [wCell.imageView setImageWithURL:user.imageUrl
                            placeholderImage:KGRoundedPlaceholderImage(CGSizeMake(40, 40))
                                     options:SDWebImageHandleCookies | SDWebImageAvoidAutoSetImage
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       UIImage *roundedImage = KGRoundedImage(image, CGSizeMake(40, 40));
                                       wCell.imageView.image = roundedImage;
                                   }
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.imageView removeActivityIndicator];
            
            return cell;
        }
            
        case kSectionLeave: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultTableViewCellReuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:kDefaultTableViewCellReuseIdentifier];
            }
            cell.textLabel.text = @"Leave Channel";
            cell.textLabel.textColor = [UIColor kg_blueColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
            
        default:
            break;
    }
    
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kSectionTitle: {
            
            break;
        }
            
        case kSectionInformation: {
            
            break;
        }
            
        case kSectionNotification: {
            
            break;
        }
            
        case kSectionMembers: {
            NSInteger lastRowNumber = [self numberOfMembersInChannel] + kSectionMembersMinNumberOfRows - 1;
            if (indexPath.row == 0 || indexPath.row == lastRowNumber) {
                if (indexPath.row == 0) {
                    self.isAdditionMembers = YES;
                } else {
                    self.isAdditionMembers = NO;
                }
                [self navigateToMembers];
            }
            break;
            
        }
        case kSectionLeave: {
            
            break;
        }
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionTitle) {
        return kTableViewTitleCellHeight;
    }
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == kSectionTitle) {
        return kTableViewTitleSectionHeaderHeight;
    }
    if (section == kSectionMembers ) {
        return kTableViewMembersSectionHeaderHeight;
    }
    return kTableViewOtherSectionsHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == kSectionMembers) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
        header.textLabel.font = [UIFont kg_regular16Font];
        header.textLabel.text = [NSString stringWithFormat:@"%d MEMBERS", [self numberOfMembersInChannel]];
            
        return header;
    }
    
    return [UIView new];
}

- (void)navigateToMembers {
    [self performSegueWithIdentifier:kPresentMembersSegueIdentier sender:nil];
}


#pragma mark - Action
- (IBAction)leftBarButtonItemAction:(id)sender {
    [self dismissAction];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIStatusBar sharedStatusBar] moveToPreviousView];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPresentMembersSegueIdentier]) {
        KGMembersViewController *vc = segue.destinationViewController;
        vc.channel = self.channel;
        vc.isAdditionMembers = self.isAdditionMembers;
    }
}


#pragma mark - Private
//FIXME: унифицировать вывод имени - например @getmaxx(Igor Vedeneev) или @jufina
- (NSString*)configureUserName:(KGUser *)user {
    if (!user.lastName.length) {
        return (!user.firstName.length) ? user.nickname : [NSString stringWithFormat:@"%@ (%@)", user.nickname, user.firstName];
    }
    return [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
}
// Fix this later
- (NSString*)configureStatus:(KGUser *)user {
    switch([user.status integerValue]) {
        case 0:
            return nil;
        
            
        default:
            return nil;
            
    }
}

- (NSInteger)numberOfMembersInChannel {
    return self.channel.members.count;
}

@end