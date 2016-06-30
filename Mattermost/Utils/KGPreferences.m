//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGPreferences.h"
#import "NSObject+EnumerateProperties.h"

@implementation KGPreferences

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static KGPreferences*  sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance load];
    });
    return sharedInstance;
}

- (void)load  {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self enumeratePropertiesWithBlock:^(NSString *propertyName) {
        [self setValue:[defaults valueForKey:propertyName] forKey:propertyName];
    }];
}

- (void)save {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self enumeratePropertiesWithBlock:^(NSString *propertyName) {
        [defaults setValue:[[self valueForKey:propertyName] description] forKey:propertyName];
    }];
    [defaults synchronize];

}

@end