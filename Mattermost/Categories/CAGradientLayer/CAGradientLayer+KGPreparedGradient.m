//
//  CAGradientLayer+KGPreparedGradient.m
//  Mattermost
//
//  Created by Mariya on 15.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "CAGradientLayer+KGPreparedGradient.h"
#import "UIColor+KGPreparedColor.h"

@implementation CAGradientLayer (KGPreparedGradient)

+ (CAGradientLayer *)kg_blueGradientForNavigationBar {
    UIColor *colorOne = [UIColor kg_topColorForGradientBlue];
    UIColor *colorTwo = [UIColor kg_bottomColorForGradientBlue];
    return [self makeGradientForColorOne:colorOne ToColorTwo:colorTwo];
}

+ (CAGradientLayer *)makeGradientForColorOne:(UIColor *)colorOne ToColorTwo:(UIColor *)colorTwo {
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}


@end
