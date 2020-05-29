//
//  BYReplayPopView.h
//  BYGPS
//
//  Created by miwer on 16/9/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYReplayModel;

@interface BYReplayPopView : UIView

@property(nonatomic,strong) BYReplayModel * model;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *deviceModel;

@property (nonatomic,copy) void(^getAddressBlock)(void);

@end
