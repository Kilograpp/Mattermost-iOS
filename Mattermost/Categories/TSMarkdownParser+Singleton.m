//
//  TSMarkdownParser+Singleton.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "TSMarkdownParser+Singleton.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"

@implementation TSMarkdownParser (Singleton)

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self standardParser];
        [sharedInstance setupAttrubutes];
    });
    return sharedInstance;
}

- (void)setupAttrubutes {
    [self setupDefaultAttrubutes];
    [self setupHeaderAttributes];
    [self setupOtherAttributes];
}

- (void)setupDefaultAttrubutes {
    self.defaultAttributes = @{ NSFontAttributeName            : [UIFont kg_regular15Font],
                                NSForegroundColorAttributeName : [UIColor kg_blackColor] };
}

- (void)setupHeaderAttributes {
    NSMutableArray *headerAttrubutes  = [NSMutableArray array];
    
    for(int i = 0; i < 6; i++) {
        NSDictionary *attr = @{ NSFontAttributeName            : [UIFont kg_semiboldFontOfSize:26 - 2 * i],
                                NSForegroundColorAttributeName : [UIColor kg_blackColor] };
        [headerAttrubutes addObject:attr];
    }
    
    self.headerAttributes = headerAttrubutes.copy;
}

- (void)setupOtherAttributes {
    self.emphasisAttributes = @{ NSFontAttributeName            : [UIFont kg_italic15Font],
                                 NSForegroundColorAttributeName : [UIColor kg_blackColor] };
}

@end
