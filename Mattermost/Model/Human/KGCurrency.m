#import "KGCurrency.h"
#import "KGError.h"
#import <RestKit.h>

@interface KGCurrency ()

// Private interface goes here.

@end

@implementation KGCurrency

+ (RKEntityMapping *)entityMapping {
    
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromArray:@[ @"base", @"rate"]];
    [mapping addAttributeMappingsFromDictionary:@{ @"name" : @"title" }];
    
    return mapping;
}

+ (NSArray *)responseDescriptors {
    NSMutableArray *responseDescriptors = [NSMutableArray array];
    
    [responseDescriptors addObject:[RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:@"expenses/currencies"
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    return responseDescriptors.copy;
}


@end
