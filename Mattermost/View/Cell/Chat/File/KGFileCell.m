//
//  KGFileCell.m
//  Mattermost
//
//  Created by Tatiana on 22/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGFileCell.h"
#import "KGFile.h"
#import "KGDrawer.h"

@implementation KGFileCell


#pragma mark - Setup

- (void)drawRect:(CGRect)rect {
    [[KGDrawer sharedInstance] drawFile:self.file inRect:rect];
}
#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;
        self.file = file;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}


@end