#import "_KGPost.h"

@interface KGPost : _KGPost

- (BOOL)isUnread;

+ (NSString*)listPathPattern;
+ (NSString*)creationPathPattern;
+ (NSString*)updatePathPattern;

@end
