#import "_KGUser.h"

typedef NS_ENUM(NSInteger, KGUserNetworkStatus) {
    KGUserOnlineStatus,
    KGUserAwayStatus,
    KGUserOfflineStatus,
    KGUserUnknownStatus
};

@interface KGUser : _KGUser


- (KGUserNetworkStatus)networkStatus;

- (NSURL*) imageUrl;


+ (NSString*)authPathPattern;
+ (NSString*)socketPathPattern;
+ (NSString*)avatarPathPattern;
+ (NSString*)uploadAvatarPathPattern;
+ (NSString*)usersStatusPathPattern;
+ (NSString*)logoutPathPattern;
+ (NSString*)attachDevicePathPattern;
+ (NSString *)fullUsersListPathPattern;
- (NSString*)stringFromNetworkStatus;
@end
