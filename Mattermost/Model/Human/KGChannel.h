#import "_KGChannel.h"

typedef NS_ENUM(NSInteger, KGChannelType) {
    KGChannelTypePrivate,
    KGChannelTypePublic,
    KGChannelTypeUnknown
};

@interface KGChannel : _KGChannel

- (KGChannelType)type;
- (NSString*)notificationsName;

+ (NSString*)extraInfoPathPattern;
+ (NSString*)listPathPattern;

+ (NSString *)titleForChannelBackendType:(NSString *)backendType;

@end
