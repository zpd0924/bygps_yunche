//
//  UIImage+Process.m
//  GDHealth
//
//  Created by michael on 2017/6/19.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import "UIImage+Process.h"

@implementation UIImage (Process)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

- (instancetype)redrawOriginToSize:(CGSize)size {
    if (size.width <= self.size.width || size.height <= self.size.height) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    [self drawAtPoint:CGPointMake((size.width - self.size.width) * .5f, (size.height - self.size.height) *.5f)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

- (instancetype)imageByScalingAndCroppingForSize:(CGSize)targetSize
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
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        //
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
            scaledWidth = width * scaleFactor;
            scaledHeight = height * scaleFactor;
        }
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) {
        BYLog(@"could not scale image");
    }
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSData *)getImageDataByScalingCroppingAndCompressImageWithMaxSize:(NSUInteger)maxSize maxCompression:(CGFloat)maxCompression
{
    BYLog(@"压缩前：JPEGData = %.2fkb", UIImageJPEGRepresentation(self, 1.0).length / 1024.0);
    
    CGFloat compression = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    UIImage *newImage = self;
    if (UIImageJPEGRepresentation(self, compression).length > maxSize) {
        CGFloat imageWidth = MIN(self.size.width, 1280);
        newImage = [self imageByScalingAndCroppingForSize:CGSizeMake(imageWidth, imageWidth * self.size.height / self.size.width)];
    }
    while (imageData.length > maxSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(newImage, compression);
    }
    
    BYLog(@"压缩后：JPEGCompressionData = %.2fkb", imageData.length / 1024.0);
    
    return imageData;
}

@end
