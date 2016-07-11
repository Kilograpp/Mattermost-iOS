//
//  KGUserStatus.h
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKResponseDescriptor, RKObjectMapping;

@interface KGUserStatus : NSObject

@property (nonatomic, copy) NSString *backendStatus;
@property (nonatomic, copy) NSString *identifier;

+ (RKResponseDescriptor *)statusResponseDescriptor;
+ (NSString*)usersStatusPathPattern;
+ (RKObjectMapping*)objectMapping;

@end
