//
//  BYDeviceListHeader.h
//  BYGPS
//
//  Created by miwer on 16/8/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDeviceListHeader : UIView

@property(nonatomic,assign) BOOL isResetAll;//点击重置按钮达到选中全部的效果
@property(nonatomic,copy) void (^onlineTypeBlock) (NSInteger onlineType);
@property(nonatomic,copy) void (^deviceTypeSelectBlock) ();
@property(nonatomic,copy) void (^groupSelectBlock) ();

@end
