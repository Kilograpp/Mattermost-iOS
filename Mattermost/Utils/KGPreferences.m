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

- (void)load {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self enumeratePropertiesWithBlock:^(NSString *propertyName) {
        if ([propertyName isEqualToString:NSStringFromSelector(@selector(shouldCompressImages))]) {
            if (![defaults valueForKey:propertyName]) {
                [defaults setBool:YES forKey:propertyName];
                [defaults synchronize];
            }
        }
        
        if (defaults.dictionaryRepresentation[propertyName]) {
            [self setValue:[defaults valueForKey:propertyName] forKey:propertyName];
        } else {
            [self setValue:nil forKey:propertyName];
        }
    }];
}

- (void)save {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [self enumeratePropertiesWithBlock:^(NSString *propertyName) {
        if ([propertyName isEqualToString:NSStringFromSelector(@selector(shouldCompressImages))]) {
            if (![defaults valueForKey:propertyName]) {
                [defaults setBool:YES forKey:propertyName];
            }
            [defaults setBool:self.shouldCompressImages forKey:propertyName];
        } else {
            [defaults setValue:[[self valueForKey:propertyName] description] forKey:propertyName];
        }
    }];
    [defaults synchronize];

}

- (void)reset {
    [self resetDefaults];
}

- (void)resetDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [NSUserDefaults resetStandardUserDefaults];
    [userDefaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [userDefaults synchronize];
    [self load];
}


@end