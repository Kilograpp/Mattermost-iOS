//
//  KGTheme.m
//  Mattermost
//
//  Created by Maxim Gubin on 08/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTheme.h"
#import "NSObject+EnumerateProperties.h"
#import <RestKit/RestKit.h>

@implementation KGTheme

+ (RKObjectMapping*)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromDictionary:@{
        @"buttonBg"           : [KGThemeAttributes buttonBackground],
        @"linkColor"          : [KGThemeAttributes link],
        @"mentionBj"          : [KGThemeAttributes mentionBackground],
        @"sidebarBg"          : [KGThemeAttributes sidebarBackground],
        @"buttonColor"        : [KGThemeAttributes button],
        @"sidebarText"        : [KGThemeAttributes sidebarTextColor],
        @"mentionColor"       : [KGThemeAttributes mention],
        @"centerChannel"      : [KGThemeAttributes channelCenter],
        @"centerChannelBg"    : [KGThemeAttributes channelCenterBackground],
        @"sidebarHeaderBg"    : [KGThemeAttributes sidebarHeaderBackground],
        @"sidebarUnreadText"  : [KGThemeAttributes sidebarUnreadTextColor],
        @"mentionHighlightBg" : [KGThemeAttributes mentionHighlightBackground],
        
    }];
    [mapping addAttributeMappingsFromArray:@[
        [KGThemeAttributes awayIndicator],
        [KGThemeAttributes mentionHighlightLink],
        [KGThemeAttributes onlineIndicator],
        [KGThemeAttributes sidebarHeaderTextColor],
        [KGThemeAttributes sidebarTextActiveBorder],
        [KGThemeAttributes sidebarTextActiveColor],
    ]];
    return mapping;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        [self enumeratePropertiesWithBlock:^(NSString *propertyName, KGPropertyType type) {
            [self setValue:[decoder decodeObjectForKey:propertyName] forKey:propertyName];
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self enumeratePropertiesWithBlock:^(NSString *propertyName, KGPropertyType type) {
        [encoder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
    }];
}

@end


@implementation KGThemeAttributes

+(NSString*)sidebarHeaderTextColor{
    return @"sidebarHeaderTextColor";
}
+(NSString*)awayIndicator{
    return @"awayIndicator";
}
+(NSString*)buttonBackground {
    return @"buttonBackground";
}
+(NSString*)button {
    return @"button";
}
+(NSString*)channelCenterBackground{
    return @"channelCenterBackground";
}
+(NSString*)channelCenter{
    return @"channelCenter";
}
+(NSString*)link{
    return @"link";
}
+(NSString*)mentionBackground{
    return @"mentionBackground";
}
+(NSString*)mention{
    return @"mention";
}
+(NSString*)mentionHighlightBackground{
    return @"mentionHighlightBackground";
}
+(NSString*)mentionHighlightLink{
    return @"mentionHighlightLink";
}
+(NSString*)onlineIndicator{
    return @"onlineIndicator";
}
+(NSString*)sidebarBackground{
    return @"sidebarBackground";
}
+(NSString*)sidebarHeaderBackground{
    return @"sidebarHeaderBackground";
}
+(NSString*)sidebarTextColor{
    return @"sidebarTextColor";
}
+(NSString*)sidebarTextActiveBorder{
    return @"sidebarTextActiveBorder";
}
+(NSString*)sidebarTextActiveColor{
    return @"sidebarTextActiveColor";
}
+(NSString*)sidebarUnreadTextColor{
    return @"sidebarUnreadTextColor";
}

@end