//
//  BYCarTypeSetModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeSetModel.h"

@implementation BYCarTypeSetModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"series_id" :@"id",@"series_name" :@"seriesName",@"series_group_name" :@"seriesGroupName"};
}
@end
