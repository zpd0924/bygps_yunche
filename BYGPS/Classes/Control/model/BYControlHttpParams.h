//
//  BYControlHttpParams.h
//  BYGPS
//
//  Created by ZPD on 2017/11/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYControlHttpParams : NSObject

@property (nonatomic,assign) NSInteger mark;//1查找附近 0根据设备查询
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,strong) NSString *deviceIds; // mark为0必传，设备id（批量）以逗号分开
@property (nonatomic,strong) NSString *queryStr;//设备号，车牌号，车主姓名

@end
