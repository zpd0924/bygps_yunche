//
//  BYEvaluationPhotoModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYEvaluationPhotoModel.h"


@implementation BYEvaluationPhotoModel

+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress fullPath:(NSString *)fullPath{
    BYPhotoModel * model = [[BYPhotoModel alloc] init];
    model.image = image;
    model.isP_HImage = isP_HImage;
    model.imageAddress = imageAddress;
//    model.fullPath = fullPath;
    return model;
}

@end
