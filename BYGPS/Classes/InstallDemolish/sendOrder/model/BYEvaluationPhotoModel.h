//
//  BYEvaluationPhotoModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYPhotoModel.h"

@interface BYEvaluationPhotoModel : NSObject
@property(nonatomic,strong) UIImage * image;
@property(nonatomic,assign) BOOL isP_HImage;//是否是占位图片
@property (nonatomic,strong) NSString *imageAddress;
@property (nonatomic,strong) NSString *fullPath;

+(BYPhotoModel *)createModelWith:(UIImage *)image isP_HImage:(BOOL)isP_HImage imageAddress:(NSString *)imageAddress fullPath:(NSString *)fullPath;
@end
