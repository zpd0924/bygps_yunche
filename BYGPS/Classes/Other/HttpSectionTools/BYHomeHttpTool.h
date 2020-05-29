//
//  BYHomeHttpTool.h
//  BYGPS
//
//  Created by miwer on 16/8/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYHomeHttpTool : NSObject

+(void)GETUnreadCountWith:(NSInteger)count success:(void (^)(id data))success;

+(void)POSTHomeStatusCountSuccess:(void (^)(id data))success isShowFlower:(BOOL)isShowFlower;//获取设备状态的数量


+(void)POSTHomeRingChartCountSuccess:(void(^)(id data))success isShowFlower:(BOOL)showFlower;//获取全换数据

+(void)POSTHomeAlarmCountSuccess:(void (^)(id data))success;//获取报警条数

+(void)cancelOperation;//取消网络请求

@end
