//
//  BYKeepDeviceInfoStatusModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYKeepDeviceInfoStatusModel : NSObject
///原因说明
@property (nonatomic,strong) NSString *resonStr;
///是否选中
@property (nonatomic,assign) BOOL isSelect;
///故障描述
@property (nonatomic,strong) NSString *resonInfoStr;
@end
