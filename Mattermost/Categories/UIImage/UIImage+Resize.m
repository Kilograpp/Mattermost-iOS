// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Resize.h"
//#import "UIImage+RoundedCorner.h"
//#import "UIImage+Alpha.h"

// Private helper methods
@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality {
//    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
//                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
//                                         interpolationQuality:quality];
//    
//    // Crop out any part of the image that's larger than the thumbnail size
//    // The cropped rect must be centered on the resized image
//    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
//    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
//                                 round((resizedImage.size.height - thumbnailSize) / 2),
//                                 thumbnailSize,
//                                 thumbnailSize);
//    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
//    
//    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
//
//    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
//}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize roundCorners:(CGFloat)radius
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
//        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
//        
//        if (widthFactor > heightFactor)
//        {
//            scaleFactor = widthFactor; // scale to fit height
//        }
//        else
//        {
            scaleFactor = heightFactor; // scale to fit width
//        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        // center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        }
//        else
//        {
//            if (widthFactor < heightFactor)
//            {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//            }
//        }
    }
    
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, (CGRect){CGPointZero, targetSize});
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, targetSize}
                                cornerRadius:radius] addClip];
    

    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    

    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (void)roundedImage:(UIImage *)image
         whithRadius:(CGFloat)radius
                size:(CGSize)size
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        UIImage* roundedImage = [image imageByScalingAndCroppingForSize:size roundCorners:radius];
//        CGRect rect = CGRectMake(0, 0, size.width, size.height);
//        
//        [[UIBezierPath bezierPathWithRoundedRect:rect
//                                    cornerRadius:radius] addClip];
//        // Draw your image
//        [image drawInRect:rect];
//        
//        // Get the image, here setting the UIImageView image
//        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//        
//        // Lets forget about that we were drawing
//        UIGraphicsEndImageContext();
        dispatch_async( dispatch_get_main_queue(), ^{
            if (completion) {
                completion(roundedImage);
            }
        });
    });
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)kg_transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:break;
    }
    
    return transform;
}

+ (void)roundedImage:(UIImage *)image
        cornerRadius:(CGFloat)cornerRadius
          completion:(void (^)(UIImage *image))completion {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGRect rect = CGRectMake(0, 0, image.size.width,image.size.height);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:rect
                                    cornerRadius:cornerRadius] addClip];
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


- (UIImage *)kg_resizedImageWithMaxWidth:(CGFloat)maxWidth
{
    if (self.size.width > maxWidth) {
        CGFloat scale = maxWidth / self.size.width;
        CGSize newSize = CGSizeMake(maxWidth, self.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    return self.copy;
}

//- (UIImage *)kg_resizedImageWithSize:(CGSize)size {
//    UIGraphicsBeginImageContext(size);
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return destImage;
//}

- (instancetype)kg_imageByReplacingAlphaWithColor:(UIColor*)color {
    CGRect frame = {CGPointZero, self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, frame);
    [self drawInRect:frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (instancetype)kg_resizedImageWithHeight:(CGFloat)height {
    height = [[UIScreen mainScreen] scale] * height;
    CGFloat scale = self.size.width / self.size.height;
    CGSize size = CGSizeMake(height * scale, height);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


UIImage *KGRoundedImage(UIImage *sourceImage, CGSize size)
{
    CGRect frame = {CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, frame);
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:ceilf(size.width/2)] addClip];
    [sourceImage drawInRect:frame];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
    
    
}

UIImage *KGRoundedPlaceholderImage(CGSize size)
{
    static dispatch_once_t once;
    static id image;
    dispatch_once(&once, ^{
        CGRect rect = CGRectMake(0, 0, 40, 40);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef ref = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20].CGPath;
        CGContextAddPath(context, ref);
        CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
        CGContextFillPath(context);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    
    return image;
}


UIImage *KGRoundedPlaceholderImageForAttachmentsCell(CGSize size)
{
    static dispatch_once_t once;
    static id image;
    dispatch_once(&once, ^{
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f, (CGRectGetWidth([UIScreen mainScreen].bounds) - 61.f) * 0.66f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef ref = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
        CGContextAddPath(context, ref);
        CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.95f alpha:1.f] CGColor]);
        CGContextFillPath(context);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    
    return image;
    
}

@end
