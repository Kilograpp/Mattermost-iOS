#import "_KGPost.h"

@interface KGPost : _KGPost

@property (nonatomic, strong, nullable) NSAttributedString* attributedMessage;

- (BOOL)isUnread;

+ (NSString* _Nonnull)nextPageListPathPattern;
+ (NSString* _Nonnull)firstPagePathPattern;
+ (NSString* _Nonnull)creationPathPattern;
+ (NSString* _Nonnull)updatePathPattern;
- (NSArray*  _Nonnull)sortedFiles;
@end
