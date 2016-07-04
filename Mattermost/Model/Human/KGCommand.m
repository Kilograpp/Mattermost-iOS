#import "KGCommand.h"
#import <RestKit/RestKit.h>
#import "KGPostAction.h"
#import "KGErrorAction.h"
#import "KGMoveAction.h"
#import "NSStringUtils.h"

@interface KGCommand ()

// Private interface goes here.

@end

@implementation KGCommand


+ (RKEntityMapping *)entityMapping {
    RKEntityMapping *mapping = [super emptyEntityMapping];
    [mapping setIdentificationAttributes:@[[KGCommandAttributes name]]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"display_name"       : [KGCommandAttributes name],
            @"auto_complete_desc" : [KGCommandAttributes message],
            @"auto_complete_hint" : [KGCommandAttributes hint]
    }];
    [mapping addAttributeMappingsFromArray:@[[KGCommandAttributes trigger]]];
    return mapping;
}

+ (RKDynamicMapping*)executeMapping {
    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        if ([[representation valueForKey:@"response_type"] isEqualToString:@"in_channel"]) {
            return [KGPostAction mapping];
        }
        if ([[representation valueForKey:@"response_type"] isEqualToString:@"ephemeral"]) {
            if ([NSStringUtils isStringEmpty:[representation valueForKey:@"goto_location"]]) {
                return [KGErrorAction mapping];
            }
            return [KGMoveAction mapping];
        }

        return [self emptyResponseMapping];
    }];
    return dynamicMapping;
}


+ (NSString*)executePathPattern {
    return @"teams/:identifier/commands/execute";
}

+ (NSString*)listPathPattern {
    return @"teams/:identifier/commands/list";
}

+ (RKResponseDescriptor*)initialLoadResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:[self listPathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor*)executeResponseDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[self executeMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self executePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}




@end
