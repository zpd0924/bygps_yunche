//
//  BYControlModel.h
//  BYGPS
//
//  Created by miwer on 16/9/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceInfoModel.h"

@interface BYControlModel : BYDeviceInfoModel

@property(nonatomic,assign) NSInteger iconId;

@property(nonatomic,assign) CGFloat pop_H;

@property (nonatomic,strong) NSString *name;//围栏名

@property (nonatomic,strong) NSString *parameter;//中心点或多边形的点

@property (nonatomic,assign) NSInteger type;//围栏类别 1:圆,2:矩形，3:多边形，4:省

@property (nonatomic,assign) NSInteger inorout;//1出围栏 2 入围栏 3出省

@property (nonatomic,assign) double radius;//圆形围栏半径

@property (nonatomic,strong) NSString *centerLat;//多边形中心点经度

@property (nonatomic,strong) NSString *centerLon;//多边形中心点纬度

@end
