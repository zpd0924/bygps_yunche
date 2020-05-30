//
//  BYShareCommitDeviceModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/26.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYShareCommitDeviceModel : NSObject
///设备ID
@property (nonatomic,strong) NSString *deviceId;
///设备号
@property (nonatomic,strong) NSString *deviceSn;
///有线或者无线 0有线 1无线
@property (nonatomic,assign) NSInteger deviceType;
///有线或者无线 0有线 1无线
@property (nonatomic,assign) NSInteger wifi;
///设备型号
@property (nonatomic,strong) NSString *deviceModel;
///设备型号别名

@property (nonatomic , strong) NSString *alias;

///是否选中
@property (nonatomic,assign) BOOL isSelect;
@end
