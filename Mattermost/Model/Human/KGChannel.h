#import "_KGChannel.h"

typedef NS_ENUM(NSInteger, KGChannelType) {
    KGChannelTypePrivate,
    KGChannelTypePublic
};

@interface KGChannel : _KGChannel

- (KGChannelType)type;

+ (NSString*)listPathPattern;
@end
