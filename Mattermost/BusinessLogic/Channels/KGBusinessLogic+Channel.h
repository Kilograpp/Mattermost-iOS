//
// Created by Maxim Gubin on 08/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGBusinessLogic.h"

@interface KGBusinessLogic (Channel)

- (void)loadChannelsWithCompletion:(void(^)(KGError *error))completion;

@end