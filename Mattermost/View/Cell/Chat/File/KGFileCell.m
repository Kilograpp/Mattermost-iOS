//
//  KGFileCell.m
//  Mattermost
//
//  Created by Tatiana on 22/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGFileCell.h"
//#import <Masonry/Masonry.h>
#import "KGFile.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "UIImage+Resize.h" 
#import "KGUIUtils.h"

@implementation KGFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.layer.drawsAsynchronously = YES;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self setupIconImageView];
        [self setupNameLabel];
        [self setupSizeLabel];
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupIconImageView {
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.drawsAsynchronously = YES;
    self.iconImageView.clipsToBounds = YES;
    [self addSubview:self.iconImageView];

}

- (void)setupNameLabel {
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.backgroundColor = [UIColor kg_whiteColor];
    self.nameLabel.textColor = [UIColor kg_blueColor];
    self.nameLabel.font = [UIFont kg_regular16Font];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:self.nameLabel];
}

- (void)setupSizeLabel {
    self.sizeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.sizeLabel.clipsToBounds = YES;
    self.sizeLabel.backgroundColor = [UIColor kg_whiteColor];
    self.sizeLabel.textColor = [UIColor kg_lightGrayColor];
    self.sizeLabel.font = [UIFont kg_regular16Font];
    self.sizeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self addSubview:self.sizeLabel];
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGFile class]]) {
        KGFile *file = object;
        UIImage *icon = [UIImage imageNamed:@"chat_file_ic"];
        self.iconImageView.image = icon;
        NSString *name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
        self.nameLabel.text = name;
        self.sizeLabel.text = fileSizeString(file);
    }
}


#pragma mark - Lifecycle

- (void)layoutSubviews {
    self.iconImageView.frame = CGRectMake(8, 8, 40, 40);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5, 8, self.bounds.size.width - 64, 20);
    self.sizeLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 5, 100, 15);
}


#pragma mark - Private

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
