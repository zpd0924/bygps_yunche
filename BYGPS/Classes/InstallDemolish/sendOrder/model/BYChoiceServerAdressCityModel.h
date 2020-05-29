//
//  BYChoiceServerAdressCityModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/31.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYChoiceServerAdressCityModel : NSObject
///市id
@property (nonatomic,strong) NSString *cityId;
///市名称
@property (nonatomic,strong) NSString *cityName;
///首字母
@property (nonatomic,strong) NSString *firstCode;
///首字母是否隐藏
@property (nonatomic,assign) BOOL isHidden;

@end
