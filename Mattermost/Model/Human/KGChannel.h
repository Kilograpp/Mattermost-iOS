#import "_KGChannel.h"
#import "KGUser.h"

typedef NS_ENUM(NSInteger, KGChannelType) {
    KGChannelTypePrivate,
    KGChannelTypePublic,
    KGChannelTypeUnknown
};


@interface KGChannel : _KGChannel


- (BOOL)hasNewMessages;

- (KGChannelType)type;
- (NSString*)notificationsName;

- (KGUserNetworkStatus)networkStatus;

+ (NSString*)extraInfoPathPattern;

+ (NSString*)updateLastViewDatePathPattern;

+ (NSString*)listPathPattern;

+ (NSString*)moreListPathPattern;

+ (NSString *)titleForChannelBackendType:(NSString *)backendType;

- (NSString *)interlocuterId;

@end
