//
//  BYGroupShareNode.m
//  BYGPS
//
//  Created by 李志军 on 2019/1/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYGroupShareNode.h"

@implementation BYGroupShareNode
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"nodeName": @"name",@"childs":@"children"}];
}

@end
