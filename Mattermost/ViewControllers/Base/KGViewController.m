//
//  KGViewController.m
//  Mattermost
//
//  Created by Igor Vedeneev on 07.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGViewController.h"


@interface KGViewController ()

@end

@implementation KGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Error processing

- (void)processError:(KGError *)error {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] ;
    [alert show];
}

@end
