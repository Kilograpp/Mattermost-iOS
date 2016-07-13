#import "_KGPost.h"

@interface KGPost : _KGPost

@property (nonatomic, strong, nullable) NSAttributedString* attributedMessage;
@property (nonatomic, strong, readonly) NSArray * _Nullable nonImageFiles;
@property (nonatomic, assign, readonly) BOOL hasAttachments;

- (BOOL)isUnread;
- (NSTimeInterval)timeIntervalSincePost:(KGPost *)post;
- (void)configureBackendPendingId;

+ (NSString* _Nonnull)nextPageListPathPattern;
+ (NSString* _Nonnull)firstPagePathPattern;
+ (NSString* _Nonnull)creationPathPattern;
+ (NSString* _Nonnull)updatePathPattern;
- (NSArray*  _Nonnull)sortedFiles;

//- (NSArray * _Nullable)nonImageFiles;

bool postsHaveSameAuthor(KGPost *post1, KGPost *post2);

@end
