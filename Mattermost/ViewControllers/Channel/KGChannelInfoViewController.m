//
//  KGChannelInfoViewController.m
//  Mattermost
//
//  Created by Julia Samoshchenko on 20.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGChannelInfoViewController.h"
#import "UIStatusBar+SharedBar.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGChannel.h"
#import "KGTeam.h"

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
    kSectionMembersNumberOfRows = 5,
    kSectionLeaveNumberOfRows = 1,
};

static CGFloat const kTableViewFirstSectionHeaderHeight = 0.1f;
static CGFloat const kTableViewOtherSectionsHeaderHeight = 15.f;


@interface KGChannelInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *detailsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *users;


@end

@implementation KGChannelInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIStatusBar sharedStatusBar] restoreState];
    [self setupCloseBarItem];
    [self setupTitle];
    [self fillTitlesArray];
    [self fillDetailsArray];
    [self fillUsersArray];
    
    [self setupTableView];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionTitle) {
        return 80.f;
    }
    if (indexPath.section == kSectionMembers) {
        return 60.f;
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == kSectionTitle) {
        return kTableViewFirstSectionHeaderHeight;
    }
    return kTableViewOtherSectionsHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == kSectionMembers) {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.textLabel.font = [UIFont kg_regular14Font];
    header.textLabel.text = [NSString stringWithFormat:@"%d members", (int)self.channel.members.count];
    return header;
    }
    return [UIView new];
}

#pragma mark - TableViewDatasource

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
            return kSectionMembersNumberOfRows;
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
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultStyleCell"];
            
            cell.textLabel.text = self.channel.name;
            cell.imageView.image = [UIImage imageNamed:@"about_kg_icon"];
            return cell;
        }
            
        case kSectionInformation: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultStyleCell"];
            cell.textLabel.text = [self.titlesArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.detailsArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        case kSectionNotification: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultStyleCell"];
            cell.textLabel.text = @"Notification";
            cell.imageView.image = [UIImage imageNamed:@"profile_notification_icon"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
        case kSectionMembers: {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultStyleCell"];
                cell.textLabel.text = @"Add Members";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor kg_blueColor];
                return cell;
            }
            if (indexPath.row == (kSectionMembersNumberOfRows - 1)) {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultStyleCell"];
                cell.textLabel.text = @"See all Members";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor kg_blueColor];
                return cell;
            }
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultStyleCell"];
                cell.imageView.image = [UIImage imageNamed:@"about_mattermost_icon"];
            /*
                KGUser *user = [self.users objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", user.status];
             */
                return cell;
                                     
        }
        case kSectionLeave: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultStyleCell"];
            cell.textLabel.text = @"Leave Channel";
            cell.textLabel.textColor = [UIColor kg_blueColor];
            
            return cell;
        }
            
        default:
            break;
    }
    return [UITableViewCell new];
}

#pragma mark - Setup

- (void)fillTitlesArray {
    self.titlesArray = @[@"Header", @"Purpose", @"URL", @"ID"];
}

// TODO self.channel.team -> URL
- (void)fillDetailsArray {
    self.detailsArray = @[self.channel.header, self.channel.purpose, @"kilograpp", self.channel.identifier];
}

- (void)fillUsersArray {
    self.users = [self.channel.members allObjects];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)setupCloseBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeChannelInfo)];
}

- (void)setupTitle {
    self.title = @"Channel Info";
}

#pragma mark - Action

- (void)closeChannelInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

