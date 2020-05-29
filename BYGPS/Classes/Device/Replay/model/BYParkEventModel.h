//
//  BYParkEventModel.h
//  BYGPS
//
//  Created by ZPD on 2017/8/9.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYParkEventModel : JSONModel

@property (nonatomic,strong) NSString *parkingTime;//停车持续时间
@property (nonatomic,strong) NSString *beginTime;//停车开始时间
@property (nonatomic,strong) NSString *endTime;//停车结束时间
@property (nonatomic,strong) NSString *address;//停车位置描述
@property (nonatomic,assign) float lat;//停车时的经度
@property (nonatomic,assign) float lng;//停车时的纬度
//@property (nonatomic,assign) NSInteger duration;//停车持续时间（秒）
@property (nonatomic,assign) CGFloat pop_H;

@end
