//
//  BYBaseNode.m
//  BYGPS
//
//  Created by miwer on 16/9/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseNode.h"

@implementation BYBaseNode

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId": @"id"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
