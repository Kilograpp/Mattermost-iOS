#import "_KGUser.h"

@interface KGUser : _KGUser
- (NSURL*) imageUrl;
+ (NSString*) authPathPattern;
+ (NSString*)avatarPathPattern;
+ (NSString*) attachDevicePathPattern;
@end
