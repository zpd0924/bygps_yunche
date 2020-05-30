//
//  BYOrderDetailModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYOrderDetailModel : NSObject
///派单用户姓名
@property (nonatomic,strong) NSString *createUserName;
///派单公司名称
@property (nonatomic,strong) NSString *groupName;
///派单公司ID
@property (nonatomic,assign) NSInteger groupId;
///技师姓名
@property (nonatomic,strong) NSString *technicianName;
///技师id
@property (nonatomic,strong) NSString *technicianId;
///技师电话
@property (nonatomic,strong) NSString *technicianPhone;
///省份
@property (nonatomic,strong) NSString *province;
///省份id
@property (nonatomic,assign) NSInteger provinceId;
///城市id
@property (nonatomic,assign) NSInteger cityId;
///区id
@property (nonatomic,assign) NSInteger areaId;
///城市
@property (nonatomic,strong) NSString *city;
///区
@property (nonatomic,strong) NSString *area;
///安装地址
@property (nonatomic,strong) NSString *installAddress;
///派单类型 0：指派 1：抢单
@property (nonatomic,assign) NSInteger publishType;
///是否需要审核  0：不需要 1：只需要 2:全部
@property (nonatomic,assign) NSInteger needToAudit;
///派单备注
@property (nonatomic,strong) NSString *orderRemark;
///技师备注
@property (nonatomic,strong) NSString *installRemark;
///车牌
@property (nonatomic,strong) NSString *carNum;
///车架号
@property (nonatomic,strong) NSString *carVin;
///车型
@property (nonatomic,strong) NSString *carModel;
///车颜色
@property (nonatomic,strong) NSString *carColor;
///车主
@property (nonatomic,strong) NSString *carOwnerName;
///车id
@property (nonatomic,assign) NSInteger carId;
///车品牌
@property (nonatomic,strong) NSString *carBrand;
///车系
@property (nonatomic , strong) NSString *carType;

///设备服务商
@property (nonatomic,strong) NSString *deviceProvider;
///设备类型 0.有限设备 1.无线设备 3.其他设备
@property (nonatomic,assign) NSInteger deviceType;
///设备号
@property (nonatomic,strong) NSString *sn;
///数量
@property (nonatomic,assign) NSInteger count;
///退审原因
@property (nonatomic,strong) NSString *approveReason;
///订单状态 0待安装 1已接单 2安装完成 3审核不通过 4审核通过 5撤销
@property (nonatomic,assign) NSInteger orderStatus;
///gps设备
@property (nonatomic,strong) NSMutableArray *gps;

///订单创建时间
@property (nonatomic,strong) NSString *createTime;
///退接单时间
@property (nonatomic,strong) NSString *technicianTakeTime;
///技师安装完成时间
@property (nonatomic,strong) NSString *technicianFinishTime;
///审核时间
@property (nonatomic,strong) NSString *approveTime;
///联系人
@property (nonatomic,strong) NSString *contactPerson;
///联系人电话
@property (nonatomic,strong) NSString *contactTel;
///拆机原因1 清货拆机、2 关联错误、3 悔货拆机 
@property (nonatomic,assign) NSInteger uninstallReson;
///工单编号
@property (nonatomic,strong) NSString *orderNo;
///工单类型 0：全部,1:安装,2:检修,3:拆机
@property (nonatomic,assign) NSInteger serviceType;

@end
