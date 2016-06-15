//
//  KGImageCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGImageCell.h"

@implementation KGImageCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.kg_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height - 8.f )];
    self.kg_imageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
    self.kg_imageView.layer.drawsAsynchronously = YES;
    self.layer.drawsAsynchronously = YES;
    self.kg_imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.kg_imageView];
    self.layer.shouldRasterize = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)prepareForReuse {
    self.kg_imageView.image = nil;
}

- (void)drawRect:(CGRect)rect {
    
}

@end
