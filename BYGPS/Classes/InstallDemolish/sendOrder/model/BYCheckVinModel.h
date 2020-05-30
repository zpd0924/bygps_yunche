//
//  BYCheckVinModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCheckVinModel : NSObject
///1车架号校验，=2车牌号校验
@property (nonatomic,assign) NSInteger uniqueProperty;
///0未派单,=1在派单
@property (nonatomic,assign) NSInteger status;
///=0校验通过，=1校验未通过
@property (nonatomic,assign) NSInteger checkCarNum;
@end
