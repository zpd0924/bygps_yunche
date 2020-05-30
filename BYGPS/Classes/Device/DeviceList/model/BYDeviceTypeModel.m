//
//  BYDeviceTypeModel.m
//  BYGPS
//
//  Created by miwer on 16/9/18.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceTypeModel.h"

@implementation BYDeviceTypeModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"devicetypeid":@"id"}];
}

@end
