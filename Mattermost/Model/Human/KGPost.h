#import "_KGPost.h"

@interface KGPost : _KGPost

@property (nonatomic, strong, nullable) NSAttributedString* attributedMessage;

- (BOOL)isUnread;

+ (NSString*)listPathPattern;
+ (NSString*)creationPathPattern;
+ (NSString*)updatePathPattern;
- (NSArray *)sortedFiles;
@end
