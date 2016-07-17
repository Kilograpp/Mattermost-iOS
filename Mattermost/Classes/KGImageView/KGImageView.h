//
//  KGImageView.h
//  Nabiraem
//
//  Created by Dmitry Arbuzov on 26/03/15.
//  Copyright (c) 2015 Kilogramm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGImageView : UIImageView
@property (nonatomic, copy) void(^tapHandler)();
@end
