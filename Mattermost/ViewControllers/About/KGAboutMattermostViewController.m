//
//  KGAboutMattermostViewController.m
//  Mattermost
//
//  Created by Julia Samoshchenko on 18.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAboutMattermostViewController.h"

@interface KGAboutMattermostViewController ()
@property (strong, nonatomic) NSTimer* iconsResizeAnimationTimer;

@property (weak, nonatomic) IBOutlet UIImageView *iconKGImageView;
@property (weak, nonatomic) IBOutlet UITextView *mattermostLinkView;
@property (weak, nonatomic) IBOutlet UITextView *kilograppLinkView;

@end

@implementation KGAboutMattermostViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitle];
    [self setupLinks];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(self.iconsResizeAnimationTimer) {
        [self.iconsResizeAnimationTimer invalidate];
        self.iconsResizeAnimationTimer = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
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

- (void)setupLinks {
    NSURL *urlKilograppTeam = [NSURL URLWithString:@"http://kilograpp.com/"];
    NSURL *urlMattermost = [NSURL URLWithString:@"https://mattermost.org/"];
    NSMutableAttributedString *mattermostString = [[NSMutableAttributedString alloc] initWithString:@"Join the Mattermost community at mattermost.org"];
    NSMutableAttributedString *kilograppString = [[NSMutableAttributedString alloc] initWithString:@"This application was developed by Kilograpp Team"];
    NSRange mattermostLinkRange = [[mattermostString string] rangeOfString:@"mattermost.org"];
    NSRange kilograppLinkRange = [[kilograppString string] rangeOfString:@"Kilograpp Team"];
    [mattermostString addAttribute:NSLinkAttributeName value:urlMattermost  range:mattermostLinkRange];
    [kilograppString addAttribute:NSLinkAttributeName value:urlKilograppTeam range:kilograppLinkRange];
    
    self.kilograppLinkView.attributedText = kilograppString;
    self.mattermostLinkView.attributedText = mattermostString;
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
