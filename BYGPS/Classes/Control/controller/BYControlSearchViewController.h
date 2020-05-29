//
//  BYControlSearchViewController.h
//  BYGPS
//
//  Created by ZPD on 2018/4/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYControlSearchViewController : UIViewController

//type  1 control , 2 deviceList , 3 alarmList
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) void(^searchCallBack)(NSString *searchStr);

@end
