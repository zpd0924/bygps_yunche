//
//  BYPhotoModel.h
//  BYGPS
//
//  Created by miwer on 2017/3/5.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPhotoModel : NSObject

@property(nonatomic,strong) UIImage * image;
@property(nonatomic,assign) BOOL isP_HImage;//是否是占位图片
@property (nonatomic,strong) NSString *imageAddress;
@property (nonatomic,strong) NSString *fullPath;

+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress;

+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress fullPath:(NSString *)fullPath;
@end
