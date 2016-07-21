#import "KGTeam.h"
#import <RestKit.h>

@interface KGTeam ()

// Private interface goes here.

@end

@implementation KGTeam


+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"display_name" : @"displayName",
                                                  }];
    [mapping addAttributeMappingsFromArray:@[@"name"]];
    
    return mapping;
}


+ (RKObjectMapping*)initialLoadConfigMapping {
    RKObjectMapping *dictionaryMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [dictionaryMapping addAttributeMappingsFromDictionary:@{
            @"SiteName" : @"siteName"
    }];
    return dictionaryMapping;
}

+ (NSString*)teamListingsPathPattern {
    return @"teams/all_team_listings";
}

+ (NSString*)initialLoadPathPattern {
    return @"users/initial_load";
}

+ (RKResponseDescriptor*)initalLoadResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self initialLoadPathPattern]
                                                       keyPath:@"teams"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)initalLoadConfigResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self initialLoadConfigMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self initialLoadPathPattern]
                                                       keyPath:@"client_cfg"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}




+ (RKResponseDescriptor*)teamListingsResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self teamListingsPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}



@end
