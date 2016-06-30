#import "_KGFile.h"
@class UIImage;
@interface KGFile : _KGFile

- (NSURL *)thumbLink;
- (NSURL *)downloadLink;
- (NSURL *)localUrl;
- (BOOL)isImage;

+ (RKEntityMapping *)simpleEntityMapping;
+ (NSString*)updatePathPattern;
+ (NSString*)thumbLinkPathPattern;
+ (NSString*)downloadLinkPathPattern;

+ (NSString*)uploadFilePathPattern;

@end
