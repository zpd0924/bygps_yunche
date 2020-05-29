//
//  BYPhotoModel.m
//  BYGPS
//
//  Created by miwer on 2017/3/5.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYPhotoModel.h"

@implementation BYPhotoModel

+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress{
    BYPhotoModel * model = [[BYPhotoModel alloc] init];
    model.image = image;
    model.isP_HImage = isP_HImage;
    model.imageAddress = imageAddress;
    return model;
}
+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress fullPath:(NSString *)fullPath{
    BYPhotoModel * model = [[BYPhotoModel alloc] init];
    model.image = image;
    model.isP_HImage = isP_HImage;
    model.imageAddress = imageAddress;
    model.fullPath = fullPath;
    return model;
}

@end
