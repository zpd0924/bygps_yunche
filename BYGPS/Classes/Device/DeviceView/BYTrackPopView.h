//
//  BYTrackPopView.h
//  BYGPS
//
//  Created by miwer on 16/9/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BYUnderlineButtonView.h"

@class BYTrackModel;

@interface BYTrackPopView : UIView

@property(nonatomic,strong) BYTrackModel * model;

@property(nonatomic,strong) NSString * address;//经纬度位置

@property (nonatomic,strong) NSString * subAddress;

@property(nonatomic,assign) CGFloat distance;//我俩距离

@property (nonatomic,strong) NSArray *buttonItems;

@property (nonatomic) NSInteger selectedIndex;

@property(nonatomic,copy) void (^dismissBlcok) (void);

@property(nonatomic,copy) void (^sponsorPhotoBlock)(NSString *address);
@property (nonatomic,copy) void(^gotoBaiduMapBlock)(void);
@property (nonatomic,copy) void(^gotoReplayBlock)(void);

@property (nonatomic,copy) void(^getLocationChangeBlock)(NSInteger type);

@end
