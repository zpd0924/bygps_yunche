//
//  BYCityModel.h
//  xsxc
//
//  Created by ZPD on 2018/6/5.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "JSONModel.h"

@interface BYCityModel : JSONModel

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pinyin;
@property (nonatomic,strong) NSString *shortName;

@property (nonatomic,strong) NSString *initial;

@end
