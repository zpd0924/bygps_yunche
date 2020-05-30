
//
//  BYChoiceServerAdressModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressModel.h"

@implementation BYChoiceServerAdressModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"pid" :@"id",@"pName":@"name"};
}
@end
