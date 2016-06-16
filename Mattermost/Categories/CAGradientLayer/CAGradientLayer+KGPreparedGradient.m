//
//  CAGradientLayer+KGPreparedGradient.m
//  Mattermost
//
//  Created by Mariya on 15.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "CAGradientLayer+KGPreparedGradient.h"
#import "UIColor+KGPreparedColor.h"

static int kAnimationDuration = 10;

@implementation CAGradientLayer (KGPreparedGradient)


+ (CAGradientLayer *)kg_blueGradientForNavigationBar {
    UIColor *topColor = [UIColor kg_topBlueColorForGradient];
    UIColor *bottomColor = [UIColor kg_bottomBlueColorForGradient];
    return [self makeGradientForTopColor:topColor ToBottomColor:bottomColor];
}

+ (CAGradientLayer *)makeGradientForTopColor:(UIColor *)topColor ToBottomColor:(UIColor *)bottomColor {
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSNumber *stopTop = [NSNumber numberWithFloat:0.0];
    NSNumber *stopBottom = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopTop, stopBottom, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

- (void)animateLayer:(CAGradientLayer *)headerLayer forTopColor:(UIColor *)topColor toBottomColor:(UIColor *)bottomColor {
    NSArray *fromColors = headerLayer.colors;
    NSArray *toColors = @[(id)topColor.CGColor,
                          (id)bottomColor.CGColor];
    
    [headerLayer setColors:toColors];
    [headerLayer addAnimation:[self addBaseAnimationForColors:fromColors toColors:toColors] forKey:@"animateGradient"];
}

- (CABasicAnimation *)addBaseAnimationForColors:(NSArray *)fromColors toColors:(NSArray *)toColors{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = kAnimationDuration;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate              = self;
    
    return animation;
}

- (void)animateLayerInfinitely:(CAGradientLayer *)headerLayer{
    NSArray *colorsArray = [self makeArrayColors:headerLayer];
    int64_t timeDelay = 0;
    for (int i = 1; i < colorsArray.count; i ++) {
        timeDelay = i*kAnimationDuration;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeDelay * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [headerLayer setColors:[colorsArray objectAtIndex:i]];
            [headerLayer addAnimation:[self addBaseAnimationForColors:[colorsArray objectAtIndex:i-1] toColors:[colorsArray objectAtIndex:i]] forKey:@"animateGradient"];
            if (i + 1 == colorsArray.count) {
                [self  animateLayerInfinitely:headerLayer];
            }
        });

    }
}


- (NSArray *)makeArrayColors:(CAGradientLayer *)headerLayer {
    NSArray *fromColors = headerLayer.colors;
    NSArray *toColors1 = @[(id)[UIColor kg_topGreenColorForGradient].CGColor,
                          (id)[UIColor kg_bottomGreenColorForGradient].CGColor];
    NSArray *toColors2 = @[(id)[UIColor kg_topOrangeColorForGradient].CGColor,
                             (id)[UIColor kg_bottomOrangeColorForGradient].CGColor];
    NSArray *toColors3 = @[(id)[UIColor kg_topRedColorForGradient].CGColor,
                             (id)[UIColor kg_bottomRedColorForGradient].CGColor];
    NSArray *toColors4 = @[(id)[UIColor kg_topPurpleColorForGradient].CGColor,
                             (id)[UIColor kg_bottomPurpleColorForGradient].CGColor];
    NSArray *toColors5 = @[(id)[UIColor kg_topBlueColorForGradient].CGColor,
                            (id)[UIColor kg_bottomBlueColorForGradient].CGColor];
    
    NSArray *colorsArray = [NSArray arrayWithObjects:fromColors,toColors1,toColors2,toColors3,toColors4,toColors5, nil];
    
    return colorsArray;  
}


@end
