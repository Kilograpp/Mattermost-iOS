//
//  CAGradientLayer+KGPreparedGradient.h
//  Mattermost
//
//  Created by Mariya on 15.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAGradientLayer (KGPreparedGradient)

+ (CAGradientLayer *)kg_blueGradientForNavigationBar;
+ (CAGradientLayer *)makeGradientForColorOne:(UIColor *)colorOne ToColorTwo:(UIColor *)colorTwo;

@end
