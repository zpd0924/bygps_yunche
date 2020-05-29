//
//  BYScreenParameterModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/8/1.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYScreenParameterModel : NSObject
///工单类型 0：全部,1:安装,2:检修,3:拆机
@property (nonatomic,assign) NSInteger serviceType;
///筛选情况下 4：完成  1:未完成
@property (nonatomic,assign) NSInteger status;
///工单进度 2：正常 1：超时
@property (nonatomic,assign) NSInteger isOvertimes;
///开始时间
@property (nonatomic,strong) NSString *startTime;
///结束时间
@property (nonatomic,strong) NSString *endTime;
///1：筛选
@property (nonatomic,assign) NSInteger type;
///是否有操作
@property (nonatomic,assign) BOOL isOperation;
@end
