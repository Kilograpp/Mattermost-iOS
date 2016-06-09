#import "_KGUser.h"

@interface KGUser : _KGUser
- (NSURL*) imageUrl;
+ (NSString*) authPathPattern;
+ (NSString*) attachDevicePathPattern;
@end
