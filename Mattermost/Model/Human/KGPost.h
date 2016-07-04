#import "_KGPost.h"

@interface KGPost : _KGPost

@property (nonatomic, strong, nullable) NSAttributedString* attributedMessage;

- (BOOL)isUnread;

+ (NSString* _Nonnull)listPathPattern;
+ (NSString* _Nonnull)creationPathPattern;
+ (NSString* _Nonnull)updatePathPattern;
- (NSArray*  _Nonnull)sortedFiles;
@end
