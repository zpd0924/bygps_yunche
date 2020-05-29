//
//  BYCarMessageSearchViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<车辆信息搜索
#import <UIKit/UIKit.h>
#import "BYSearchCarByNumOrVinModel.h"
#import "BYNaviSearchBar.h"

typedef enum : NSUInteger {
    carNumScanType,
    vinNumScanType,
    deviceScanType,
} ScanType;

@interface BYCarMessageSearchViewController : UIViewController
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) void(^searchCallBack)(BYSearchCarByNumOrVinModel *model);
@property (nonatomic,assign) BYSendOrderType sendOrderType;
@property (nonatomic,assign) ScanType scanType;
@property (nonatomic,assign) NSInteger carId;//当前汽车id
@property (nonatomic,strong) NSString *keyWord;//搜索关键字
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;
@end
