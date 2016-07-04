//
//  KGAction.h
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKObjectMapping;
@interface KGAction : NSObject

- (void)execute;
+ (RKObjectMapping*)mapping;

@end
