//
//  BYPostBackModel.m
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackModel.h"

@implementation BYPostBackModel

+(BYPostBackModel *)createModelWith:(NSString *)title detail:(NSString *)detail placeholder:(NSString *)placeholder unit:(NSString *)unit{
    BYPostBackModel * model = [[BYPostBackModel alloc] init];
    model.title = title;
    model.detail = detail;
    model.palceholder = placeholder;
    model.unit = unit;
    return model;
}

@end
