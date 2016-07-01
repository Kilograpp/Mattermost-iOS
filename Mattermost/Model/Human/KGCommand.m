#import "KGCommand.h"
#import <RestKit/RestKit.h>
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
    return [RKResponseDescriptor responseDescriptorWithMapping:[self emptyResponseMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:[self executePathPattern]
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}


@end
