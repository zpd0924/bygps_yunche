//
//  BYFenceControl.h
//  BYGPS
//
//  Created by ZPD on 2017/9/1.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYFenceControl : NSObject

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) BOOL BYControlIsOpenMonitor;//监控页面是否打开高危
@property (nonatomic,assign) BOOL BYTrackIsOpenMonitor;//监控页面是否打开高危
@property (nonatomic,assign) BOOL BYAlarmIsOpenMonitor;//报警详情页是否打开高危

@end
