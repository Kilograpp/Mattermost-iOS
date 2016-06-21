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
+ (CAGradientLayer *)makeGradientForTopColor:(UIColor *)topColor ToBottomColor:(UIColor *)bottomColor;
+ (CAGradientLayer *)setupGradientForTopColor:(UIColor *)topColor ToBottomColor:(UIColor *)bottomColor;
- (void)animateLayer:(CAGradientLayer *)headerLayer forTopColor:(UIColor *)topColor toBottomColor:(UIColor *)bottomColor;
- (void)animateLayerInfinitely:(CAGradientLayer *)headerLayer;

@end
