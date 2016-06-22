//
//  KGFileCell.m
//  Mattermost
//
//  Created by Tatiana on 22/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGFileCell.h"
#import <Masonry.h>
#import "KGFile.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"

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
        UIImage *icon = [UIImage imageNamed:@"profile_name_icon"];
        [[self class] roundedImage:icon completion:^(UIImage *image) {
            self.iconImageView.image = image;
        }];
        NSString *name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
        self.nameLabel.text = name;
        self.sizeLabel.text = @"0KB";
    }
}

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
        //        CGRect rect = CGRectMake(0, 0, KG_IMAGE_WIDTH, KG_IMAGE_HEIGHT);
        
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:image.size.width/2] addClip];
        // Draw your image
        [image drawInRect:rect];
        
        // Get the image, here setting the UIImageView image
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        dispatch_async( dispatch_get_main_queue(), ^{
            if (completion) {
                completion(roundedImage);
            }
        });
    });
}
@end
