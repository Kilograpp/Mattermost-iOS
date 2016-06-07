//
//  ViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "ViewController.h"
#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Session.h"
#import <MagicalRecord.h>
#import "KGCurrency.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[KGBusinessLogic sharedInstance] loginWithEmail:@"maxim@kilograpp.com" password:@"loladin" completion:^(KGError *error) {}];
    
    
}

@end
