//
//  BYMyAllWorkOrderModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYMyAllWorkOrderModel : JSONModel
///工单号
@property (nonatomic,strong) NSString *orderNo;
///工单时间
@property (nonatomic,strong) NSString *createTime;
///公司名称
@property (nonatomic,strong) NSString *name;
///派单用户姓名
@property (nonatomic,strong) NSString *createUserName;
///派单公司ID
@property (nonatomic,assign) NSInteger groupId;
///技师id
@property (nonatomic,assign) NSInteger technicianId;
///联系人
@property (nonatomic,strong) NSString *contactPerson;
///联系电话
@property (nonatomic,strong) NSString *contactTel;
///车牌
@property (nonatomic,strong) NSString *carNum;
///车架号
@property (nonatomic,strong) NSString *carVin;
///车品牌
@property (nonatomic , strong) NSString *carBrand;
///车系
@property (nonatomic , strong) NSString *carType;
///车型
@property (nonatomic,strong) NSString *carModel;

///省份
@property (nonatomic,strong) NSString *province;
///城市
@property (nonatomic,strong) NSString *city;
///区
@property (nonatomic,strong) NSString *area;
///安装详细地址
@property (nonatomic,strong) NSString *serviceAddress;

///工单状态 0待接单 1已接单 2待审核 3审核不通过 4审核通过 5撤销
@property (nonatomic,assign) NSInteger status;
///服务类别 1:安装,2:检修,3:拆机
@property (nonatomic,assign) NSInteger serviceType;
///无线设备数量
@property (nonatomic,assign) NSInteger wirelessDeviceCount;
///有线设备数量
@property (nonatomic,assign) NSInteger wirelineDeviceCount;
///其它设备数量
@property (nonatomic,assign) NSInteger otherDeviceCount;
///待审核数量
@property (nonatomic,assign) NSInteger isNotuditing;
///是否评论 1:是 0：否
@property (nonatomic,assign) NSInteger isComment;
@end
