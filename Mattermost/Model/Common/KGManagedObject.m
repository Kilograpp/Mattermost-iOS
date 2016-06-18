//
//  KGManagedObject.m
//  DeliveryMaster
//
//  Created by Dmitry Arbuzov on 09/02/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGManagedObject.h"
#import <MagicalRecord/MagicalRecord.h>
#import <RestKit/RestKit.h>
#import "KGBusinessLogic.h"

@implementation KGManagedObject

+ (instancetype)managedObjectById:(NSString *)objectId {
    return [self MR_findFirstByAttribute:NSStringFromSelector(@selector(identifier)) withValue:objectId];
}

+ (instancetype)managedObjectById:(NSString *)objectId inContext:(NSManagedObjectContext *)context{
    return [self MR_findFirstByAttribute:NSStringFromSelector(@selector(identifier)) withValue:objectId inContext:context];
}

+ (instancetype)managedObjectByUserName:(NSString *)userName {
   return  [self MR_findFirstByAttribute:@"username" withValue:userName];
}



+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[self entityName]
                                                   inManagedObjectStore:[KGBusinessLogic sharedInstance].managedObjectStore];

    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingsFromDictionary:@{ @"id" : @"identifier" }];

    return mapping;
}

+ (RKObjectMapping *)emptyResponseMapping {
    return [RKObjectMapping mappingForClass:[NSNull class]];
}

+ (RKEntityMapping *)emptyEntityMapping {
    return [RKEntityMapping mappingForEntityForName:[self entityName]
                                                          inManagedObjectStore:[KGBusinessLogic sharedInstance].managedObjectStore];
}

+ (RKObjectMapping *)requestMapping {
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{ @"identifier" : @"id" }];
    
    return requestMapping;
}

+ (NSArray *)responseDescriptors {
    return nil;
}

+ (NSString *)entityName {
    return nil;
}

@end
