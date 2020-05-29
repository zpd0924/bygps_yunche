//
//  BYChoiceServerAdressAreaModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/31.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYChoiceServerAdressAreaModel : NSObject
///市id
@property (nonatomic,strong) NSString *cityId;
///区id
@property (nonatomic,strong) NSString *areaId;
///市名称
@property (nonatomic,strong) NSString *cityName;
///区名称
@property (nonatomic,strong) NSString *areaName;
///省id
@property (nonatomic,strong) NSString *pid;
///首字母
@property (nonatomic,strong) NSString *firstCode;
///首字母是否隐藏
@property (nonatomic,assign) BOOL isHidden;
@end
