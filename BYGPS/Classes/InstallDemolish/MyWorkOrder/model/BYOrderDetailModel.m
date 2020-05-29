//
//  BYOrderDetailModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYOrderDetailModel.h"
#import "BYDeviceModel.h"

@implementation BYOrderDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"gps":[BYDeviceModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"installAddress" :@"serviceAddress"};
}
@end
