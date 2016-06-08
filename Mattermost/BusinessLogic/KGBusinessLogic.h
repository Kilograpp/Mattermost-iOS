//
//  KGBusinessLogic.h
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGError.h"
@class RKObjectManager, RKMappingResult, RKManagedObjectStore;

@interface KGBusinessLogic : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic, readonly) RKObjectManager *defaultObjectManager;
@property (nonatomic, strong, readonly) RKManagedObjectStore *managedObjectStore;

@end
