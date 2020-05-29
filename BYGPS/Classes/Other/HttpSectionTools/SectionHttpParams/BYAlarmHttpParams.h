//
//  BYAlarmHttpParams.h
//  BYGPS
//
//  Created by miwer on 16/9/14.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAlarmHttpParams : NSObject

@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)NSString * showCount;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString * groupId;
@property(nonatomic,strong)NSString * alarmType;
@property(nonatomic,strong)NSString * startTime;
@property(nonatomic,strong)NSString * endTime;
@property(nonatomic,strong)NSString * queryStr;
@property(nonatomic,assign)NSInteger deviceId;

@end
