//
//  BYAddCarInfoModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAddCarInfoModel : NSObject
///汽车id
@property (nonatomic,assign) NSInteger carId;
///车架号
@property (nonatomic,strong) NSString *carVin;
///车牌号
@property (nonatomic,strong) NSString *carNum;
///车牌号 头部
@property (nonatomic,strong) NSString *carFirstNum;
///车牌号 尾部
@property (nonatomic,strong) NSString *carLastNum;
///所属分组
@property (nonatomic,strong) NSString *groupName;
///所属分组id
@property (nonatomic,strong) NSString *groupId;
///车主姓名
@property (nonatomic,strong) NSString *ownerName;
///所属公司
@property (nonatomic,strong) NSString *company;
///所属公司id
@property (nonatomic,strong) NSString *companyId;
///车辆品牌
@property (nonatomic,strong) NSString *brand;
///车系
@property (nonatomic,strong) NSString *carType;
///车辆型号
@property (nonatomic,strong) NSString *carModel;
///车辆颜色
@property (nonatomic,strong) NSString *color;
///其他颜色填写
@property (nonatomic,strong) NSString *otherColor;
///车主电话
@property (nonatomic,strong) NSString *ownerTel;
///合同编号
@property (nonatomic,strong) NSString *contractNo;


@end
