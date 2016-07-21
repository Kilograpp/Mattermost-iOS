//
//  KGConstants.h
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString             *const KGRestKitClassPrefix;

// Todo, Code Review: Исправить опечатку в слове standard
extern float                 const KGStandartCornerRadius;
extern NSTimeInterval        const KGStandartAnimationDuration;


#pragma mark - HTTP Constants

extern NSString * const KGXRequestedWithHeader;
extern NSString * const KGContentTypeHeader;
extern NSString * const KGAcceptLanguageHeader;
extern NSString * const KGSocketProtocol;

#pragma mark - Internal 

extern NSString * const KGUserDefaultsPreferencesKey;


#pragma mark - Local notification

extern NSString * const KGNotificationDidReceiveNewMessage;
