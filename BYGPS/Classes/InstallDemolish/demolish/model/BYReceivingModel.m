//
//  BYReceivingModel.m
//  父子控制器
//
//  Created by miwer on 2016/12/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYReceivingModel.h"
#import "DeviceItem.h"

@implementation BYReceivingModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

-(void)setSnMessageAssembly:(NSString *)snMessageAssembly
{
    _snMessageAssembly = snMessageAssembly;
    
    NSArray *messageArr = [snMessageAssembly componentsSeparatedByString:@","];
    for (NSString *messageStr in messageArr) {
        DeviceItem *item = [[DeviceItem alloc] init];
        NSArray *deviceArr = [messageStr componentsSeparatedByString:@"_"];
        item.sn = deviceArr[0];
        item.model = deviceArr[1];
        item.wireLess = deviceArr[2];
        [self.list addObject:item];
    }
}


-(NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
@end

