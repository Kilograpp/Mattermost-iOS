//
//  KGTheme.h
//  Mattermost
//
//  Created by Maxim Gubin on 08/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;
@class RKObjectMapping;

@interface KGTheme : NSObject <NSCoding>

@property (strong, nonatomic) UIColor* awayIndicator;
@property (strong, nonatomic) UIColor* buttonBackground;
@property (strong, nonatomic) UIColor* button;
@property (strong, nonatomic) UIColor* channelCenterBackground;
@property (strong, nonatomic) UIColor* channelCenter;
@property (strong, nonatomic) UIColor* link;
@property (strong, nonatomic) UIColor* mentionBackground;
@property (strong, nonatomic) UIColor* mention;
@property (strong, nonatomic) UIColor* mentionHighlightBackground;
@property (strong, nonatomic) UIColor* mentionHighlightLink;
@property (strong, nonatomic) UIColor* onlineIndicator;
@property (strong, nonatomic) UIColor* sidebarBackground;
@property (strong, nonatomic) UIColor* sidebarHeaderBackground;
@property (strong, nonatomic) UIColor* sidebarHeaderTextColor;
@property (strong, nonatomic) UIColor* sidebarTextColor;
@property (strong, nonatomic) UIColor* sidebarTextActiveBorder;
@property (strong, nonatomic) UIColor* sidebarTextActiveColor;
@property (strong, nonatomic) UIColor* sidebarUnreadTextColor;

+ (RKObjectMapping*)mapping;
@end


@interface KGThemeAttributes : NSObject

+(NSString*)sidebarHeaderTextColor;
+(NSString*)awayIndicator;
+(NSString*)buttonBackground;
+(NSString*)button;
+(NSString*)channelCenterBackground;
+(NSString*)channelCenter;
+(NSString*)link;
+(NSString*)mentionBackground;
+(NSString*)mention;
+(NSString*)mentionHighlightBackground;
+(NSString*)mentionHighlightLink;
+(NSString*)onlineIndicator;
+(NSString*)sidebarBackground;
+(NSString*)sidebarHeaderBackground;
+(NSString*)sidebarTextColor;
+(NSString*)sidebarTextActiveBorder;
+(NSString*)sidebarTextActiveColor;
+(NSString*)sidebarUnreadTextColor;

@end