//
//  BYSearchCarByNumOrVinModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSearchCarByNumOrVinModel : NSObject
///车辆id
@property (nonatomic,assign) NSInteger carId;
///车牌号
@property (nonatomic,strong) NSString *carNum;
///车架号
@property (nonatomic,strong) NSString *carVin;
///所属公司
@property (nonatomic,strong) NSString *company;
///车辆品牌
@property (nonatomic,strong) NSString *brand;
///车系列
@property (nonatomic,strong) NSString *carType;
///车型号
@property (nonatomic,strong) NSString *carModel;
///车辆颜色
@property (nonatomic,strong) NSString *color;
///车主
@property (nonatomic,strong) NSString *ownerName;
///车主电话
@property (nonatomic,strong) NSString *ownerTel;

///联系关键字
@property (nonatomic,strong) NSString *keyWord;
///关联设备列表
@property (nonatomic,strong) NSArray *list;

@end
