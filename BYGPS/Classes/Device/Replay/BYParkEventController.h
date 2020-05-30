//
//  BYParkEventController.h
//  BYGPS
//
//  Created by ZPD on 2017/8/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;
@interface BYParkEventController : UIViewController

@property (nonatomic,strong) NSMutableArray *parkDatasource;
@property (nonatomic,strong) BYPushNaviModel *model;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,copy) void (^selectedRowCallBack) (NSInteger index);

@end
