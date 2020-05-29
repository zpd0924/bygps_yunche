//
//  BYMonitorHttpTool.h
//  BYGPS
//
//  Created by ZPD on 2017/11/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYMonitorHttpTool : NSObject

+(void)POSTMonitorDeviceStatusWithPragrams:(NSMutableDictionary *)params isShare:(int)isShare success:(void(^)(id data))success failure:(void (^)(NSError *))failure showError:(BOOL)showError;

+(void)POSTMonitorRealTimeTrackingWithParams:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showError:(BOOL)showError;

@end
