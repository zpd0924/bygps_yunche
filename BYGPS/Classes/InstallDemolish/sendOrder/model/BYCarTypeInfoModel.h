//
//  BYCarTypeInfoModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCarTypeInfoModel : NSObject
///车型ID
@property (nonatomic,strong) NSString *model_id;
///2013款 奥迪A4L 30TFSI 手动舒适型",//车型名称
@property (nonatomic,strong) NSString *model_name;
///指导价
@property (nonatomic,strong) NSString *model_price;
///年份
@property (nonatomic,strong) NSString *model_year;
@end
