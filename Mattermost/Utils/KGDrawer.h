//
//  KGFileDrawer.h
//  Mattermost
//
//  Created by Maxim Gubin on 16/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

@import UIKit;

@class KGFile;
@interface KGDrawer : NSObject

+ (instancetype)sharedInstance;

- (void)drawFile:(KGFile*)file inRect:(CGRect)frame;
- (void)drawImage:(UIImage*)image inRect:(CGRect)frame;
@end
