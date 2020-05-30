//
//  BYOrderPushModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/8/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYOrderPushModel : NSObject
///超时工单推送提醒 (1=不推送，2=推送)
@property (nonatomic,assign) NSInteger type30;
///待审核工单推送提醒 (1=不推送，2=推送)
@property (nonatomic,assign) NSInteger type31;
///技师确认接单(1=不推送，2=推送)
@property (nonatomic,assign) NSInteger type36;
@end
