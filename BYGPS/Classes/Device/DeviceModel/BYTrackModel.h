//
//  BYTrackModel.h
//  BYGPS
//
//  Created by miwer on 16/10/11.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceInfoModel.h"

@interface BYTrackModel : BYDeviceInfoModel

@property(nonatomic,assign) NSInteger iconId;
@property(nonatomic,assign) NSInteger direction;
@property (nonatomic,assign) NSInteger locateType;//1gps 2基站  3wifi

@property(nonatomic,assign) CGFloat pop_H;

@property (nonatomic,strong) NSString *carBrand;//车品牌
@property (nonatomic,strong) NSString *carType;//车型号
@property (nonatomic,strong) NSString *carColor;//车颜色

@property (nonatomic,strong) NSString *name;//围栏名

@property (nonatomic,strong) NSString *parameter;//中心点或多边形的点

@property (nonatomic,assign) NSInteger type;//围栏类别 1:圆,2:矩形，3:多边形，4:省

@property (nonatomic,assign) NSInteger inorout;//1出围栏 2 入围栏 3出省

@property (nonatomic,assign) double radius;//圆形围栏半径

@property (nonatomic,strong) NSString *centerLat;//多边形中心点经度

@property (nonatomic,strong) NSString *centerLon;//多边形中心点纬度

@end

/*
 {"Brand":"别克","Model":"008+","CarID":38210,"EndDate":"2016-08-04 16:00:00","GroupName":"未找到分组的设备","SN":"80201126555","Wifi":0,"beginDate":"2015-02-05 16:00:00","CarNum":"桂A4W722","OwnerName":"许亚明"}
 */
