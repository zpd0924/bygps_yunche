//
//  BYAlarmPopView.h
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYAlarmModel;

@interface BYAlarmPopView : UIView

@property(nonatomic,strong) NSString * handleType;

@property(nonatomic,strong) BYAlarmModel * model;

@property(nonatomic,strong) NSString * address;

@property(nonatomic,copy) void (^presentcBlock)();

@property(nonatomic,copy) void (^alarmHandelBlock)();

@property(nonatomic,copy) void (^sponsorPhotoBlock)(NSString *address);

@end
