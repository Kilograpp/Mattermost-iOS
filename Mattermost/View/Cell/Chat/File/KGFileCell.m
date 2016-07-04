//
//  KGFileCell.m
//  Mattermost
//
//  Created by Tatiana on 22/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGFileCell.h"
#import <Masonry/Masonry.h>
#import "KGFile.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "UIImage+Resize.h" 

static CGFloat const kSmallPadding = 5.f;
static CGFloat const kStandartPadding = 15.f;
static CGFloat const kIconSize = 45.f;

@implementation KGFileCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.layer.drawsAsynchronously = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self setupIconImageView];
    [self setupNameLabel];
    [self setupSizeLabel];
    
}

- (void)setupIconImageView {
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.iconImageView.layer.drawsAsynchronously = YES;
    self.iconImageView.clipsToBounds = YES;
    
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@45);
    }];
}

- (void)setupNameLabel {
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.nameLabel.textColor = [UIColor kg_blueColor];
    self.nameLabel.font = [UIFont kg_regular16Font];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(kSmallPadding);
        make.centerY.equalTo(self).offset(-kStandartPadding);
        make.trailing.equalTo(self).offset(kStandartPadding);
    }];
}

- (void)setupSizeLabel {
    self.sizeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.sizeLabel.clipsToBounds = YES;
    self.sizeLabel.backgroundColor = [UIColor kg_whiteColor];
    self.sizeLabel.textColor = [UIColor kg_lightGrayColor];
    self.sizeLabel.font = [UIFont kg_regular16Font];
    self.sizeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:self.sizeLabel];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(kSmallPadding);
        make.centerY.equalTo(self).offset(kStandartPadding);
    }];
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;
        UIImage *icon = [UIImage imageNamed:@"chat_file_ic"];
//        [UIImage roundedImage:icon whithRadius:icon.size.width/2 completion:^(UIImage *image) {
//            self.iconImageView.image = image;
//        }];
        self.iconImageView.image = icon;
        NSString *name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
        self.nameLabel.text = name;
        self.sizeLabel.text = fileSizeString(file);
    }
}

NSString *fileSizeString(KGFile *file) {
    float size = file.sizeValue;
    int pow = 0;
    
    while (size / 1024 >= 1) {
        size = size / 1024.f;
        pow++;
    }
    
    NSString *suffix;
    switch (pow) {
        case 0: {
            suffix = @"B";
            break;
        }
            
        case 1: {
            suffix = @"KB";
            break;
        }
            
        case 2: {
            suffix = @"MB";
            break;
        }
            
        case 3: {
            suffix = @"GB";
            break;
        }
            
        default:
            break;
    }
    
                return [NSString stringWithFormat:@"%.1F%@", size, suffix];
}

@end
