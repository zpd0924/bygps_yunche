//
//  BYRelativeModel.h
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYRelativeModel : JSONModel

@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,strong) NSString * model;
///设备别名
@property (nonatomic , strong) NSString *alias;

@property(nonatomic,strong) NSString * sn;
@property(nonatomic,assign) NSInteger deviceId;

@end

/*
 "wifi":0,是否在线
   "Model":"009",型号
       "SN":"27025069436"设备号
 */
