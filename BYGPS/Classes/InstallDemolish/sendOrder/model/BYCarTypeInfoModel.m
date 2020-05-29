//
//  BYCarTypeInfoModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeInfoModel.h"

@implementation BYCarTypeInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"model_id" :@"typeId",@"model_name" :@"modelName",@"model_price" :@"modelPrice",@"model_year" :@"modelYear"};
}
@end

