//
//  BYSearchCarByNumOrVinModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSearchCarByNumOrVinModel.h"
#import "BYDeviceModel.h"

@implementation BYSearchCarByNumOrVinModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"carId" :@"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"list":[BYDeviceModel class]
             };
}
@end
