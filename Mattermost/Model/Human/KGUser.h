#import "_KGUser.h"

typedef NS_ENUM(NSInteger, KGUserNetworkStatus) {
    KGUserOnlineStatus,
    KGUserAwayStatus,
    KGUserOfflineStatus
};

@interface KGUser : _KGUser


- (KGUserNetworkStatus)networkStatus;

- (NSURL*) imageUrl;
+ (NSString*) authPathPattern;
+ (NSString*) avatarPathPattern;
+ (NSString*) uploadAvatarPathPattern;

+ (NSString *)usersStatusPathPattern;

+ (NSString*)logoutPathPattern;

+ (NSString*) attachDevicePathPattern;
@end
