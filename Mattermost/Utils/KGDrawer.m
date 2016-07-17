//
//  KGFileDrawer.m
//  Mattermost
//
//  Created by Maxim Gubin on 16/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGDrawer.h"
#import <UIKit/UIKit.h>
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGFile.h"


@interface KGDrawer()
@property (nonatomic, copy) NSDictionary* fileNameAttributesCache;
@property (nonatomic, copy) NSDictionary* fileSizeAttributesCache;

@end

@implementation KGDrawer

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        [sharedInstance setupAttributesCache];
        [sharedInstance preloadRequiredIcons];
        
    });
    return sharedInstance;
}

- (void)setupAttributesCache {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSMutableDictionary* attributes = [@{
        NSFontAttributeName             : [UIFont kg_regular16Font],
        NSBackgroundColorAttributeName  : [UIColor kg_whiteColor],
        NSForegroundColorAttributeName  : [UIColor kg_blueColor],
        NSParagraphStyleAttributeName   : paragraphStyle
    } mutableCopy];
    
    self.fileNameAttributesCache = attributes;
    
    [attributes setValue:[UIColor kg_lightGrayColor] forKey:NSForegroundColorAttributeName];
    
    self.fileSizeAttributesCache = attributes;
}

- (void)preloadRequiredIcons {
    [self preloadImage:[UIImage imageNamed:@"chat_file_ic"]];
}

- (void)preloadImage:(UIImage*)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    CGImageRef ref = image.CGImage;
    size_t width = CGImageGetWidth(ref);
    size_t height = CGImageGetHeight(ref);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, space, kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(space);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
    CGContextRelease(context);
    
    
    UIGraphicsEndImageContext();
}

- (void)drawFile:(KGFile*)file inRect:(CGRect)frame {
    
    CGRect iconFrame = CGRectOffset(CGRectMake(5, 5, 44, 44), frame.origin.x, frame.origin.y);
    [[UIImage imageNamed:@"chat_file_ic"] drawInRect:iconFrame];
    
    NSString* name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
    CGRect nameFrame = CGRectOffset(CGRectMake(CGRectGetMaxX(iconFrame) + 5, 8, frame.size.width - 64, 20),
                                    0,
                                    frame.origin.y);    
    [name drawInRect:nameFrame
      withAttributes:self.fileNameAttributesCache];

//    CGRect fileSizeRect = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(nameFrame) + 3, 100, 17);
//
//    [fileSizeString(file) drawInRect:fileSizeRect
//                      withAttributes:self.fileSizeAttributesCache];
    
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)frame {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor kg_whiteColor] set];
    CGContextFillRect(context, frame);
    
    if (image) {
        CGFloat scale = image.size.width / image.size.height;
        CGRect imageFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.height * scale, frame.size.height);
        [image drawInRect:imageFrame];
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
