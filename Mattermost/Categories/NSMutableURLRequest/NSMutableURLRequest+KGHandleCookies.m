//
//  NSMutableURLRequest+KGHandleCookies.m
//  Mattermost
//
//  Created by Igor Vedeneev on 23.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "NSMutableURLRequest+KGHandleCookies.h"
#import <objc/runtime.h>

@implementation NSMutableURLRequest (KGHandleCookies)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setHTTPShouldHandleCookies:);
        SEL swizzledSelector = @selector(kg_setHTTPShouldHandleCookies:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


#pragma mark - Swizzling

- (void)kg_setHTTPShouldHandleCookies:(BOOL)HTTPShouldHandleCookies {
    objc_setAssociatedObject(self, @selector(HTTPShouldHandleCookies), @(YES), OBJC_ASSOCIATION_ASSIGN);
}

@end
