//
//  BYCarTypeBrandModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeBrandModel.h"

@implementation BYCarTypeBrandModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"brand_id" :@"id",@"brand_name" :@"name"};
}
@end
