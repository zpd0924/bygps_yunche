//
//  BYSendWorkParameterModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSendWorkParameterModel : NSObject

/***第一步所需参数***/
///派单公司id
@property (nonatomic,assign) NSInteger groupId;
///派单公司名称
@property (nonatomic,strong) NSString *groupCompany;
///用户ID
@property (nonatomic,assign) NSInteger userId;
///用户姓名
@property (nonatomic,strong) NSString *createUserName;
///服务类别 1:安装,2:检修,3:拆机
@property (nonatomic,assign) NSInteger serviceType;
///装机所在省份
@property (nonatomic,strong) NSString *province;
///省份ID
@property (nonatomic,assign) NSInteger provinceId;
///服务城市
@property (nonatomic,strong) NSString *city;
///城市ID
@property (nonatomic,assign) NSInteger cityId;
///服务 区
@property (nonatomic,strong) NSString *area;
///区ID
@property (nonatomic,assign) NSInteger areaId;
///车辆所在详细地址，安装地址
@property (nonatomic,strong) NSString *serviceAddress;

@property (nonatomic , strong) NSString *serviceAddressLon;

@property (nonatomic , strong) NSString *serviceAddressLat;

///联系人
@property (nonatomic,strong) NSString *contactPerson;
///联系电话
@property (nonatomic,strong) NSString *contactTel;
///派单类型 0：指派 1：抢单
@property (nonatomic,assign) NSInteger publishType;
///是否需要审核 0：不需要 1：需要
@property (nonatomic,assign) NSInteger needToAudit;
///接单技师id
@property (nonatomic,assign) NSInteger technicianId;
///技师姓名
@property (nonatomic,strong) NSString *technicianName;
///备注
@property (nonatomic,strong) NSString *orderRemark;
///拆机原因1 清货拆机、2 关联错误、3 悔货拆机 
@property (nonatomic,assign) NSInteger uninstallReson;

/**第二步所需的参数**/
///车辆ID
@property (nonatomic,assign) NSInteger carId;
///车架号
@property (nonatomic,strong) NSString *carVin;
///车辆品牌
@property (nonatomic,strong) NSString *carBrand;
///车型
@property (nonatomic,strong) NSString *carModel;
///车系
@property (nonatomic,strong) NSString *carType;
///车牌
@property (nonatomic,strong) NSString *carNum;
///车颜色
@property (nonatomic,strong) NSString *carColor;
///车主姓名
@property (nonatomic,strong) NSString *carOwnerName;
///车主电话
@property (nonatomic,strong) NSString *carOwnerTel;

@property (nonatomic,strong) NSString *contractNo;

/**第三步所需的参数**/
//


///无线设备服务商1/1,无线设备服务商2/1
@property (nonatomic,strong) NSString *wirelessDeviceProvider;
///有线设备服务商1/1,有线设备服务商2/1
@property (nonatomic,strong) NSString *wirelineDeviceProvider;
///其它设备服务商1/1,其它设备服务商2/1
@property (nonatomic,strong) NSString *otherDeviceProvider;
///无源设备数量
@property (nonatomic,assign) NSInteger wirelessDeviceCount;
///有线设备数量
@property (nonatomic,assign) NSInteger wirelineDeviceCount;
///其它设备数量
@property (nonatomic,assign) NSInteger otherDeviceCount;




///设备集合
@property (nonatomic,strong) NSMutableArray *appointServiceItemVo;






@end
