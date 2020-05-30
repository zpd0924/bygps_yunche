//
//  BYDeviceModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYDeviceModel.h"

@implementation BYDeviceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"deviceCount" :@"count",@"newestSn":@"newSn",@"NewDeviceVinImg":@"newDeviceVinImg"};
}

@end
