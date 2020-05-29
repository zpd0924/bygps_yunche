//
//  BYOTSPostBackLocateController.h
//  BYGPS
//
//  Created by ZPD on 2017/6/28.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;

@interface BYOTSPostBackLocateController : UIViewController
@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL isWireless;

@property(nonatomic,strong) NSString * cmdContent;//指令记录的指令内容


@end
