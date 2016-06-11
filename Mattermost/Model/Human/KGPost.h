#import "_KGPost.h"

@interface KGPost : _KGPost

@property (nonatomic, strong, readonly) NSString *dayString;

+ (NSString*)listPathPattern;
+ (NSString*)creationPathPattern;
@end
