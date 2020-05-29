//
//  BYPushNaviModel.h
//  BYGPS
//
//  Created by miwer on 16/9/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYPushNaviModel : JSONModel

@property(nonatomic,assign) NSInteger deviceId;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * model;
@property(nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * carVin;
@property (nonatomic,strong) NSString * carStatus;
@property (nonatomic,strong) NSString * ownerName;
@property (nonatomic,assign) NSInteger  carId;
@property(nonatomic,assign) BOOL wifi;
@property (nonatomic,strong) NSString *batteryNotifier;//电量

///分享id
@property (nonatomic,strong) NSString *shareId;
///isMark 判断是否是推送点进去的 1是 0不是
@property (nonatomic,strong) NSString *isMark;
@end
