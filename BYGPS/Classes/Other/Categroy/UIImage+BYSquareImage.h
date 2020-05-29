//
//  UIImage+BYSquareImage.h
//  BYGPS
//
//  Created by miwer on 2017/3/6.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BYSquareImage)

+ (UIImage *)squareImageWith:(UIImage *)image newSize:(CGFloat)newSize;

- (UIImage *)fixOrientation;

-(UIImage *)normalizedImage ;

//IOS 压缩图片到指定大小kb
//+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;

+(UIImage*)image:(UIImage *)sourceImage imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
