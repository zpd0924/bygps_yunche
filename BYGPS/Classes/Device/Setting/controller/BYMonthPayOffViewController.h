//
//  BYMonthPayOffViewController.h
//  BYGPS
//
//  Created by ZPD on 2018/6/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYPushNaviModel;
@interface BYMonthPayOffViewController : UIViewController

@property(nonatomic,strong) BYPushNaviModel * model;

@property (nonatomic,assign) BOOL isWireless;

@property(nonatomic,strong) NSString * cmdContent;

@end
