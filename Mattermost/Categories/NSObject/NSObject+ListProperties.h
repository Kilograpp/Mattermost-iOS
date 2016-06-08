//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ListProperties)
- (void)listPropertiesWithBlock:(void(^)(NSString* propertyName))handler;
@end