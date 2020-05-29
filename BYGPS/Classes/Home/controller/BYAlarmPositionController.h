//
//  BYAlarmPositionController.h
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAlarmPositionController : UIViewController

@property(nonatomic,strong) NSString * alarmId;

@property(nonatomic,assign) BOOL isRemoteNotification;//是否为推送跳转进来,如果是就将角标提交后台

@property(nonatomic,copy) void (^handleAlarmRefreshBlock) ();

@end
