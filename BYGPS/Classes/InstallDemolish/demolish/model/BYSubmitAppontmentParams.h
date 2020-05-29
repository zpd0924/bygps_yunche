//
//  BYSubmitAppontmentParams.h
//  BYGPS
//
//  Created by miwer on 2017/2/9.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSubmitAppontmentParams : NSObject

@property(nonatomic,strong) NSString * keyKeeper;
@property(nonatomic,strong) NSString * keeperIphone;
@property(nonatomic,strong) NSString * carPlace;
@property (nonatomic,strong) NSString * carVin;
@property (nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * ownerName;
@property(nonatomic,assign) NSInteger reason;
@property (nonatomic,strong) NSArray * deviceModel;

@end

/*
 weixinUserId String 是 微信id
 sn string 是 设备号 多传 逗号分隔
 keyKeeper String 钥匙保管人
 keeperIphone String 钥匙保管人电话
 carPlace String 停车位置
 deviceId String 是 多传 逗号分隔
 reason String 是 拆机原因
 */
