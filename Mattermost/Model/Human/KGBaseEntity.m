#import "KGBaseEntity.h"
#import "RKEntityMapping.h"
#import <RestKit.h>
@interface KGBaseEntity ()

// Private interface goes here.

@end

@implementation KGBaseEntity

+ (RKEntityMapping *)entityMapping {

    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:self.entityName
                                                   inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];

    [mapping setIdentificationAttributes:@[@"identifier"]];
    [mapping addAttributeMappingsFromDictionary:@{@"id" : @"identifier"}];

    return mapping;
}


@end
