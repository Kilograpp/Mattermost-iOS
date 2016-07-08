//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGPreferences.h"
#import "KGConstants.h"
#import "NSObject+EnumerateProperties.h"



@implementation KGPreferences

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static KGPreferences*  sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self loadInstanceFromUserDefaults] ?: [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Load & Save

+ (instancetype)loadInstanceFromUserDefaults {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:KGUserDefaultsPreferencesKey]];
}

- (void)save {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:KGUserDefaultsPreferencesKey];
    [defaults synchronize];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        [self enumeratePropertiesWithBlock:^(NSString *propertyName, KGPropertyType type) {
            
            switch (type) {
                case KGTypeObject: {
                    [self setValue:[decoder decodeObjectForKey:propertyName] forKey:propertyName];
                    break;
                }
                case KGTypePrimitiveBool: {
                    [self setValue:@([decoder decodeBoolForKey:propertyName]) forKey:propertyName];
                    break;
                }
                default : break;
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [self enumeratePropertiesWithBlock:^(NSString *propertyName, KGPropertyType type) {
        switch (type) {
            case KGTypeObject: {
                [encoder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
                break;
            }
            case KGTypePrimitiveBool: {
                [encoder encodeBool:[[self valueForKey:propertyName] boolValue] forKey:propertyName];
                break;
            }
            default : break;
        }
        
    }];
}

#pragma mark - Reset

- (void)reset {
    [self resetDefaults];
    [self resetProperties];
}

- (void)resetDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KGUserDefaultsPreferencesKey];
    [defaults synchronize];
}

- (void)resetProperties {
    [self enumeratePropertiesWithBlock:^(NSString *propertyName, KGPropertyType type) {
        switch (type) {
            case KGTypeObject: {
                [self setValue:nil forKey:propertyName];
                break;
            }
            case KGTypePrimitiveBool: {
                [self setValue:@(NO) forKey:propertyName];
                break;
            }
            default : break;
        }
    }];
}


@end