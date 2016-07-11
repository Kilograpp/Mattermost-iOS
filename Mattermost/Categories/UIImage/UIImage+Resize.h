// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds;
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

+ (void)roundedImage:(UIImage *)image
          completion:(void (^)(UIImage *image))completion;

+ (void)roundedImage:(UIImage *)image
         whithRadius: (CGFloat)radius
          completion:(void (^)(UIImage *image))completion;

+ (void)roundedImage:(UIImage *)image
         whithRadius:(CGFloat)radius
                size:(CGSize)size
          completion:(void (^)(UIImage *image))completion;

- (UIImage *)kg_resizedImageWithMaxWidth:(CGFloat)maxWidth;
//- (UIImage *)kg_resizedImageWithSize:(CGSize)size;
- (instancetype)kg_imageByReplacingAlphaWithColor:(UIColor*)color;
- (instancetype)kg_resizedImageWithHeight:(CGFloat)height;

+ (void)roundedImage:(UIImage *)image
        cornerRadius:(CGFloat)cornerRadius
          completion:(void (^)(UIImage *image))completion;

#ifdef __cplusplus
extern "C" {
#endif
    
    UIImage *KGRoundedImage(UIImage *sourceImage, CGSize size);
    UIImage *KGRoundedPlaceholderImage(CGSize size);
    UIImage *KGRoundedPlaceholderImageForAttachmentsCell(CGSize size);
    
#ifdef __cplusplus
}
#endif

@end
