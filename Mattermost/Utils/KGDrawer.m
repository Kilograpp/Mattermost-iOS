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
@property (strong, nonatomic) NSDictionary* attributes;

@end

@implementation KGDrawer

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [sharedInstance setAttributes:@{
                                       NSFontAttributeName             : [UIFont kg_regular16Font],
                                       NSBackgroundColorAttributeName  : [UIColor kg_whiteColor],
                                       NSForegroundColorAttributeName  : [UIColor kg_blueColor],
                                       NSParagraphStyleAttributeName   : paragraphStyle
                                       }];
        
    });
    return sharedInstance;
}



- (void)drawFile:(KGFile*)file inRect:(CGRect)frame {
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    CGRect iconFrame = CGRectOffset(CGRectMake(5, 5, 44, 44), frame.origin.x, frame.origin.y);
    [[UIImage imageNamed:@"chat_file_ic"] drawInRect:iconFrame];
    
    NSString* name = [[file.name componentsSeparatedByString:@"/"] objectAtIndex:1];
    CGRect nameFrame = CGRectOffset(CGRectMake(CGRectGetMaxX(iconFrame) + 5, 8, frame.size.width - 64, 20),
                                    0,
                                    frame.origin.y);    
    [name drawInRect:nameFrame
      withAttributes:self.attributes];
    
    
    NSLog(@"Passed: %f", [[NSDate date] timeIntervalSince1970] - startTime);
//    CGRect fileSizeRect = CGRectMake(CGRectGetMinX(nameFrame), CGRectGetMaxY(nameFrame) + 3, 100, 17);
//    
//    [fileSizeString(file) drawInRect:fileSizeRect
//                      withAttributes:@{
//           NSFontAttributeName            : [UIFont kg_regular16Font],
//           NSBackgroundColorAttributeName : [UIColor kg_whiteColor],
//           NSForegroundColorAttributeName : [UIColor kg_lightGrayColor],
//           NSParagraphStyleAttributeName  : paragraphStyle
//    }];
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)frame {
    
    [[UIColor kg_whiteColor] set];  ///< set clear color for stroke & fill
    CGContextFillRect(UIGraphicsGetCurrentContext(), frame);
    
    if (image) {
        CGRect imageFrame = CGRectMake(frame.origin.x, frame.origin.y, image.size.width, image.size.height);
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
