//
//  BYCityModel.m
//  xsxc
//
//  Created by ZPD on 2018/6/5.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYCityModel.h"

@implementation BYCityModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"cityId": @"id"}];
}

@end
