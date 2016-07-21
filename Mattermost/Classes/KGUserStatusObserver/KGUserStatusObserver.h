//
//  KGUserStatusObserver.h
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGUserStatus;

@interface KGUserStatusObserver : NSObject

@property (nonatomic, copy) NSArray *userStatuses;

+ (instancetype)sharedObserver;
- (void)updateWithArray:(NSArray *)array;
- (KGUserStatus *)userStatusForIdentifier:(NSString *)identifier;

@end
