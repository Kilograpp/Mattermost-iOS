#import "KGTeam.h"
#import "RKEntityMapping.h"
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


+ (NSString*)initialLoadPathPattern {
    return @"users/initial_load";
}

+ (RKResponseDescriptor*)initalResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self initialLoadPathPattern]
                                                       keyPath:@"teams"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}



@end
