//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "NSObject+EnumerateProperties.h"
#import <objc/runtime.h>

@implementation NSObject (EnumerateProperties)

- (void)enumeratePropertiesWithBlock:(void(^)(NSString* propertyName))handler {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            if (handler) {
                handler(propertyName);
            }
        }
    }
    free(properties);
}

@end