//
//  BYShareListModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYShareListModel : NSObject<NSMutableCopying>
///分享时间
@property (nonatomic,strong) NSString *createTime;
///车品牌 车系
@property (nonatomic,strong) NSString *carBrand;
@property (nonatomic,strong) NSString *carType;
///车颜色
@property (nonatomic,strong) NSString *carColor;
///分享Id
@property (nonatomic,strong) NSString *shareId;
///车辆id
@property (nonatomic,strong) NSString *carId;
///车架号
@property (nonatomic,strong) NSString *carVin;
///分享人
@property (nonatomic,strong) NSString *shareUserName;
///车主
@property (nonatomic,strong) NSString *carOwnerName;
///车牌号
@property (nonatomic,strong) NSString *carNum;
///分享有效期
@property (nonatomic,strong) NSString *shareTime;
///发送指令 Y N
@property (nonatomic,strong) NSString *sendCommand;
///是否可以发送警报配置 Y N
@property (nonatomic,strong) NSString *checkAlarm;
///备注
@property (nonatomic,strong) NSString *remark;
///地址
@property (nonatomic,strong) NSString *address;
///是否结束分享 Y N
@property (nonatomic,strong) NSString *isEnd;
///分享设备集合
@property (nonatomic,strong) NSArray *deviceShare;
///内部员工
@property (nonatomic,strong) NSMutableArray *shareLine;
///外部员工
@property (nonatomic,strong) NSMutableArray *shareMobile;
@end
