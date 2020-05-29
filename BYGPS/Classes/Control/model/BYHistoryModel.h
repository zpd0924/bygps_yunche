//
//  BYHistoryModel.h
//  BYGPS
//
//  Created by ZPD on 2018/4/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYHistoryModel : NSObject

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *controlHistory;
@property (nonatomic,strong) NSString *deviceListHistory;
@property (nonatomic,strong) NSString *alarmListHistory;
@property (nonatomic,strong) NSString *carListHistory;
@end
