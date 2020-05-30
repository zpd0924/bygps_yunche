//
//  BYRouteModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/8/29.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYRouteModel.h"
#import "BYRouteApisModel.h"
@implementation BYRouteModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"apis":[BYRouteApisModel class]
             };
}
@end
