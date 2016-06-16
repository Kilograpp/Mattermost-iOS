#import "_KGUser.h"

@interface KGUser : _KGUser
- (NSURL*) imageUrl;
+ (NSString*) authPathPattern;
+ (NSString*) avatarPathPattern;
+ (NSString*) uploadAvatarPathPattern;

+ (NSString *)usersStatusPathPattern;

+ (NSString*) attachDevicePathPattern;
@end
