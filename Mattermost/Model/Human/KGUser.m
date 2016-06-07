#import "KGUser.h"
#import <RestKit.h>

@interface KGUser ()

// Private interface goes here.

@end

@implementation KGUser

+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super entityMapping];
    [mapping addAttributeMappingsFromDictionary:@{
            @"first_name" : @"firstName",
            @"last_name"  : @"lastName",
            
    }];
    [mapping addAttributeMappingsFromArray:@[@"username", @"email"]];
    
    return mapping;
}


+ (RKResponseDescriptor*)authResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:@"users/login"
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end
