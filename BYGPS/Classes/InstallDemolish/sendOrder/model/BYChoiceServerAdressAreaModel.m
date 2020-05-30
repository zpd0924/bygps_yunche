//
//  BYChoiceServerAdressAreaModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/31.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressAreaModel.h"

@implementation BYChoiceServerAdressAreaModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"areaId" :@"id",@"cityId":@"cid",@"areaName":@"name"};
}
@end
