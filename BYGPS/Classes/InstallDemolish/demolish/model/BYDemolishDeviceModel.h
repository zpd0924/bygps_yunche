//
//  BYDemolishDeviceModel.h
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel.h>

@interface BYDemolishDeviceModel : JSONModel

@property(nonatomic,assign) BOOL isSelect;

@property(nonatomic,strong) NSString * connectionIntallImgUrl;
@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,strong) NSString * model;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * ownerName;
@property(nonatomic,strong) NSString * deviceImgUrl;
@property(nonatomic,strong) NSString * installPosition;
@property(nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * carVin;
@property(nonatomic,strong) NSString * obligateUrl;
@property(nonatomic,strong) NSString * deviceId;
//@property(nonatomic,strong) NSString * imgUrl;
@property(nonatomic,strong) NSString * remark;
@property(nonatomic,assign) CGFloat mark_H;

@end

/*
 "connectionIntallImgUrl":"",//安装链接线位置图
 "wifi":"0", // 0有线 1无线
 "model":"011",//设备类型
 "sn":"80211801977",//设备号
 "ownerName":"李万荣",//车主名
 "deviceImgUrl":"",//设备加车牌号图
 "installPosition":"鼓风机旁",
 "carNum":"京N52W52",//车牌
 "obligateUrl":"", //其他图片 逗号分隔
 "deviceId":"26918"//设备id
 */
