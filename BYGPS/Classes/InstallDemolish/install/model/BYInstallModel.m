//
//  BYInstallModel.m
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallModel.h"

@implementation BYInstallModel

+(BYInstallModel *)createModelWith:(NSString *)title placeholder:(NSString *)placeholder isNecessary:(BOOL)isNecessary postKey:(NSString *)key{
    BYInstallModel * model = [[BYInstallModel alloc] init];
    model.title = title;
    model.placeholder = placeholder;
    model.isNecessary = isNecessary;
    model.postKey = key;
    return model;
}

+(BYInstallModel *)createModelWith:(NSString *)title subTitle:(NSString *)subTitle isNecessary:(BOOL)isNecessary{
    BYInstallModel * model = [[BYInstallModel alloc] init];
    model.title = title;
    model.subTitle = subTitle;
    model.isNecessary = isNecessary;
    return model;
}

@end
