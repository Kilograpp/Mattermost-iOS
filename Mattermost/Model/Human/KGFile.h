#import "_KGFile.h"

@interface KGFile : _KGFile
- (NSURL *)thumbLink;
- (NSURL *)downloadLink;
- (BOOL)isImage;

+ (RKEntityMapping *)simpleEntityMapping;
+ (NSString*)updatePathPattern;
+ (NSString*)thumbLinkPathPattern;
+ (NSString*)downloadLinkPathPattern;

@end
