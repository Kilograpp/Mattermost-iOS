//
// Created by Maxim Gubin on 01/07/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//


#import "KGBusinessLogic.h"

@class KGAction;
@class KGCommand;
@class KGChannel;
@interface KGBusinessLogic (Commands)

- (void)updateCommandsList:(void (^)(KGError* error))completion;
- (void)executeCommandWithMessage:(NSString *)message inChannel:(KGChannel *)channel withCompletion:(void (^)(KGAction* action, KGError *error))completion;
@end