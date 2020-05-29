//
//  BYRouteApisModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/8/29.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYRouteApisModel : NSObject
@property (nonatomic,strong) NSString *apiName;
@property (nonatomic,strong) NSString *apiPath;
@property (nonatomic,strong) NSArray *servers;
@end
