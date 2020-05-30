//
//  BYDeviceListHttpTool.h
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYDeviceListHttpParams;

@interface BYDeviceListHttpTool : NSObject

+(void)POSTGroupListWith:(BYDeviceListHttpParams *)params success:(void (^)(id data,NSInteger typeIndex,NSInteger countInt))success;//设备列表的所有组

+(void)POSTDeviceListWithGroupId:(NSInteger)groupId params:(BYDeviceListHttpParams *)params success:(void (^)(id))success;//设备列表中的设备

+(void)POSTAllDeviceTypeSuccess:(void (^)(id))success;//获取所有设备类型

+(void)POSTQueryDeviceBySN:(NSString *)sn Success:(void (^)(id data))success;


@end
