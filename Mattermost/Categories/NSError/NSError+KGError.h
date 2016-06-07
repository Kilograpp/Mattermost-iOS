//
// Created by Maxim Gubin on 07/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGError;

@interface NSError (KGError)

- (KGError *)kg_error;

@end