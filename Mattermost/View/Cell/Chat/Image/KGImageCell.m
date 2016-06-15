//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"
#import <AsyncDisplayKit/ASNetworkImageNode.h>
#import <Masonry.h>

@implementation KGImageCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.kg_imageView = [[ASNetworkImageNode alloc] init];
    self.kg_imageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
    self.kg_imageView.layer.drawsAsynchronously = YES;
    self.layer.drawsAsynchronously = YES;
    self.kg_imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.kg_imageView.view];
    self.layer.shouldRasterize = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.kg_imageView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-8.f);
    }];
}

- (void)prepareForReuse {
    self.kg_imageView.image = nil;
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[NSURL class]]) {
        NSURL *url = object;
        self.kg_imageView.URL = url;
    }
}

@end
