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
#import "UIView+Align.h"

@implementation KGFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//        [self setupIconImageView];
//        [self setupNameLabel];
//        [self setupSizeLabel];
    }
    
    return self;
}


#pragma mark - Setup

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGRect iconFrame = CGRectMake(5, 5, 44, 44);
    [[UIImage imageNamed:@"chat_file_ic"] drawInRect:iconFrame];
    
    NSString* name = [[self.file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
    CGRect nameFrame = CGRectMake(CGRectGetMaxX(iconFrame) + 5, 8, self.bounds.size.width - 64, 20);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [name drawInRect:nameFrame withAttributes:@{
                                                NSFontAttributeName : [UIFont kg_regular16Font],
                                                NSBackgroundColorAttributeName : [UIColor kg_whiteColor],
                                                NSForegroundColorAttributeName : [UIColor kg_blueColor],
                                                NSParagraphStyleAttributeName : paragraphStyle
                                                }];
    
    
    [fileSizeString(self.file) drawInRect:CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(nameFrame) + 3, 100, 17) withAttributes:@{
                                                                     NSFontAttributeName : [UIFont kg_regular16Font],
                                                                     NSBackgroundColorAttributeName : [UIColor kg_whiteColor],
                                                                     NSForegroundColorAttributeName : [UIColor kg_lightGrayColor],
                                                                     NSParagraphStyleAttributeName : paragraphStyle
                                                                     }];
}

- (void)setupIconImageView {
    self.iconImageView = [[UIImageView alloc] init];
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
        self.file = file;
//        UIImage *icon = [UIImage imageNamed:@"chat_file_ic"];
//        self.iconImageView.image = icon;
//        NSString *name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
//        self.nameLabel.text = name;
//        self.sizeLabel.text = fileSizeString(file);
    }
}


#pragma mark - Lifecycle

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.iconImageView.frame = CGRectMake(5, 5, 44, 44);
//    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 5, 8, self.bounds.size.width - 64, 20);
//    self.sizeLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 5, 100, 15);
//    
//    [self alignSubviews];
//}


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
