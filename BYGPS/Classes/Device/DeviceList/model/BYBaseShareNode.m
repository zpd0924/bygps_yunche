//
//  BYBaseShareNode.m
//  BYGPS
//
//  Created by 李志军 on 2019/1/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYBaseShareNode.h"

@implementation BYBaseShareNode
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId": @"id"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
