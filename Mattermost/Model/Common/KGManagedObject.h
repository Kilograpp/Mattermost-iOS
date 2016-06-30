//
//  KGManagedObject.h
//  DeliveryMaster
//
//  Created by Dmitry Arbuzov on 09/02/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <RKObjectMapping.h>
@class RKEntityMapping, RKObjectMapping;

@protocol KGShareble <NSObject>

- (void)shareObject:(NSObject *)object;

@end



@interface KGManagedObject : NSManagedObject

+ (instancetype)managedObjectById:(NSString *)objectId;
+ (instancetype)managedObjectById:(NSString *)objectId inContext:(NSManagedObjectContext *)context;
+ (instancetype)managedObjectByUserName:(NSString *)userName;

+ (NSString *)entityName;
+ (RKEntityMapping *)entityMapping;
+ (NSArray *)responseDescriptors;
+ (RKObjectMapping *)requestMapping;
+ (RKObjectMapping *)emptyResponseMapping;
+ (RKEntityMapping *)emptyEntityMapping;

@end
