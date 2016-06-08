//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGPreferences.h"
#import "NSObject+ListProperties.h"

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

@end