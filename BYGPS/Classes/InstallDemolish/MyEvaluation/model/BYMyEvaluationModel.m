//
//  BYMyEvaluationModel.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationModel.h"

@implementation BYMyEvaluationModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}

+(BYMyEvaluationModel *)creatModelWith:(NSString *)headImgName name:(NSString *)name creatTime:(NSString *)creatTime carmodel:(NSString *)carModel evaluation:(NSString *)evaluation images:(NSMutableArray *)images
{
    BYMyEvaluationModel *model = [[self alloc] init];
    
    model.headImgName = headImgName;
    model.name = name;
    model.creatTime = creatTime;
    model.carModel = carModel;
    model.evaluation = evaluation;
    model.images = images;
    
    return model;
}

@end
