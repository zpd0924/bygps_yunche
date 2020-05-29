//
//  BYChoiceServerAdressCityModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/31.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressCityModel.h"

@implementation BYChoiceServerAdressCityModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"cityId" :@"id",@"cityName":@"name"};
}
@end
