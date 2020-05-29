//
//  BYReceivingModel.h
//  父子控制器
//
//  Created by miwer on 2016/12/19.
//  Copyright © 2016年 miwer. All rights reserved.
//



#import <JSONModel.h>
#import "DeviceItem.h"

@interface BYReceivingModel : JSONModel

@property(nonatomic,assign) BOOL isReceving;

@property(nonatomic,assign) NSInteger orderId;
@property (nonatomic,strong) NSString *orderNum;//”2013154241154”//订单编号
@property(nonatomic,assign) NSInteger statu;//订单状态，1：待抢单，2：已抢单，3：取消的订单，4已完成的订单'
@property (nonatomic,strong) NSString *snMessageAssembly;//(sn_deviceType_wifi;sn_deviceType_wifi),设备号+设备类型+有线/无线。存放组合信息(例：8012124214_013_无线;82012454124_015_有线)
@property(nonatomic,assign) NSInteger createUserId;
@property(nonatomic,assign) NSInteger finishUserId;
@property(nonatomic,strong) NSString * createTime;
@property(nonatomic,strong) NSString * compTime;
@property(nonatomic,strong) NSString * finishTime;//"2016/07/06 15:40",//完成时间
@property(nonatomic,assign) NSInteger carId;
@property(nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * carVin;
@property(nonatomic,strong) NSMutableArray * list;
@property(nonatomic,strong) NSString * groupName;
@property(nonatomic,strong) NSString * phone;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * carPar;
@property(nonatomic,strong) NSString * keyKeeper;
@property(nonatomic,strong) NSString * keeperIphone;
@property(nonatomic,strong) NSString * carPlace;
@property(nonatomic,assign) NSInteger recycleFlag;//flag为1已回收,2未回收

@end

/*
 "orderId": 121, -----订单id
 "statu": 4, -----参考上面
 "createUserId": 70, ------微信用户id
 "finishUserId": 76, -----技师的Id(抢单或者完成的技师Id)
 "createTime": "2016/07/06 15:39", -----创建时间
 "compTime": "2016/07/06 15:40", -----抢单时间
 "finishTime": "2016/07/06 15:40", -----完成时间
 "carId": 255, ------微信carid
 "carNum": "粤BU820Q", ------ 车牌
 "list": [
 {}
 ],
 "groupName": "标越科技", ----分组名
 "phone": "137690114780", -------手机号码
 "nickName": "宋泰峰", ---------技师名字
 "carPar": "丰田", ------车牌
 "keyKeeper": "哦漏", -------车钥匙人名字
 "keeperIphone": "13760114780", -------车钥匙人电话
 "carPlace": "哦咯", ----停车位置
 */
