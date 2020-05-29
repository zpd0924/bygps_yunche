//
//  BYPostBackController.h
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingController.h"

@class BYPushNaviModel;

@interface BYPostBackController : BYBaseSettingController

@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL isWireless;

@property(nonatomic,strong) NSString * cmdContent;//指令记录的指令内容

@property (nonatomic,assign) NSInteger contentType;// 1 : @"常规模式"; 2  @"抓车模式"; 3  @"固定回传点模式";4 @"心跳模式"; 7  @"";8 :@"定位模式";

@end
