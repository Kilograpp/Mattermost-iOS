//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGPreferences.h"
#import <objc/runtime.h>

@implementation KGPreferences

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load  {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self listPropertiesWithBlock:^(NSString *propertyName) {
        [self setValue:[defaults valueForKey:propertyName] forKey:propertyName];
    }];
}

- (void)save {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self listPropertiesWithBlock:^(NSString *propertyName) {
        [defaults setValue:[self valueForKey:propertyName] forKey:propertyName];
    }];
    [defaults synchronize];

}

- (void)listPropertiesWithBlock:(void(^)(NSString* propertyName))handler {
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