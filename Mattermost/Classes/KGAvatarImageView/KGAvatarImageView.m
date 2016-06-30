//
//  KGAvatarImageView.m
//  Mattermost
//
//  Created by Maxim Gubin on 10/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGAvatarImageView.h"

@implementation KGAvatarImageView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self roundCorners];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self roundCorners];
    }
    return self;
}

- (void)roundCorners {
    [[self layer] setCornerRadius:3.0f];
    [[self layer] setMasksToBounds:YES];
}

@end
