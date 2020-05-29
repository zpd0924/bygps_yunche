//
//  BYVerUpdateModel.m
//  xsxc
//
//  Created by 李志军 on 2018/7/3.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYVerUpdateModel.h"

@implementation BYVerUpdateModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"Description": @"description"}];
}
@end
