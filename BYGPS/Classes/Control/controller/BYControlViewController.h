//
//  BYControlViewController.h
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYControlViewController : UIViewController

@property(nonatomic,assign) BOOL isNaviPush;//是否为选择设备push进来

@property(nonatomic,strong) NSString * deviceIdsStr;//从设备列表传过来的deviceId字符串
@property (nonatomic,strong) NSString *shareId;///分享id
@end
