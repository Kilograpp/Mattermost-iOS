//
// Created by Maxim Gubin on 01/07/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@interface KGBusinessLogic (Commands)

- (void)updateCommandsList:(void (^)(KGError* error))completion;

@end