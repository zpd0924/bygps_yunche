//
//  BYDeviceListHttpParams.h
//  BYGPS
//
//  Created by miwer on 16/9/18.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYDeviceListHttpParams : NSObject

@property(nonatomic,strong)NSString * groupName;
@property(nonatomic,strong)NSString * online;
@property(nonatomic,strong)NSMutableArray * deviceTypeIds;
@property(nonatomic,strong)NSString * queryStr;
@property(nonatomic,strong)NSString * alarm;

@end
