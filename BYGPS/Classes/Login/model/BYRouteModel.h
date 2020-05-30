//
//  BYRouteModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/8/29.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYRouteDefModel.h"

@interface BYRouteModel : NSObject


@property (nonatomic,strong) BYRouteDefModel *defaults;
@property (nonatomic,strong) NSArray *apis;
@end
