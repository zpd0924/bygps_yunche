//
//  UIImage+Process.h
//  GDHealth
//
//  Created by michael on 2017/6/19.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Process)

/**
*  加载最原始的图片，没有渲染
*
*  @param imageName 图片名
*
*  @return 没有渲染的UIImage
*/
+ (instancetype)imageWithOriginalName:(NSString *)imageName;


/**
 *  拉伸图片(拉伸中心点)
 *
 *  @param imageName 图片名
 *
 *  @return 拉伸过后的UIImage
 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;


/**
 * 绘制一张指定size的新图片
 */
- (instancetype)redrawOriginToSize:(CGSize)size;


/**
 *  将图片等比缩放到指定的大小
 *
 *  @param targetSize 目标大小(size)
 *
 *  @return 处理过后的UIImage
 */
- (instancetype)imageByScalingAndCroppingForSize:(CGSize)targetSize;


/**
 *  获取图片二进制（通过缩放、裁剪、压缩图片）
 *
 *  @param maxSize        最大尺寸（字节）
 *  @param maxCompression 最大压缩系数（0.0~1.0）
 *
 *  @return 上传服务器的图片二进制
 */
- (NSData *)getImageDataByScalingCroppingAndCompressImageWithMaxSize:(NSUInteger)maxSize maxCompression:(CGFloat)maxCompression;


@end
