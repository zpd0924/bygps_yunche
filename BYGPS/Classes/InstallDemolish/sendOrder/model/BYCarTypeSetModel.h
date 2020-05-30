//
//  BYCarTypeSetModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYCarTypeSetModel : NSObject

///车系ID
@property (nonatomic,strong) NSString *series_id;
///车系名称
@property (nonatomic,strong) NSString *series_name;
///一汽奥迪",//车系组名
@property (nonatomic,strong) NSString *series_group_name;
@end
