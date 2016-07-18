//
//  KGAboutMattermostViewController.m
//  Mattermost
//
//  Created by Julia Samoshchenko on 18.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAboutMattermostViewController.h"

@interface KGAboutMattermostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconKGImageView;
@property (strong, nonatomic) NSTimer* iconsResizeAnimationTimer;

@end

@implementation KGAboutMattermostViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupTimer];
}


#pragma makr - Setup

- (void)setupTimer {
    self.iconsResizeAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7
                                                                      target:self
                                                                    selector:@selector(iconResizeAnimation)
                                                                    userInfo:nil
                                                                     repeats:YES
                                      ];
}

- (void)setupTitle {
    self.title = @"About Mattermost";
}


#pragma mark - KGIcon Animation

- (void)iconResizeAnimation {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.iconKGImageView.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.iconKGImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    [UIView commitAnimations];
}

@end
