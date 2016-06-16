#import "_KGChannel.h"

typedef NS_ENUM(NSInteger, KGChannelType) {
    KGChannelTypePrivate,
    KGChannelTypePublic,
    KGChannelTypeUnknown
};

@interface KGChannel : _KGChannel

- (BOOL)hasNewMessages;

- (KGChannelType)type;
- (NSString*)notificationsName;

+ (NSString*)extraInfoPathPattern;

+ (NSString*)updateLastViewDatePathPattern;

+ (NSString*)listPathPattern;

+ (NSString *)titleForChannelBackendType:(NSString *)backendType;

@end
