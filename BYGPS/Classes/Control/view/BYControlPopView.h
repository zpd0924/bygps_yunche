//
//  BYControlPopView.h
//  BYGPS
//
//  Created by miwer on 16/9/7.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYControlModel;

@interface BYControlPopView : UIView

@property(nonatomic,copy) void (^deviceDetailBlcok) (NSInteger tag);

@property(nonatomic,copy) void (^dismissBlcok) (void);

@property (nonatomic,copy) void (^gotoBaiduMapBlock)(void);

@property (nonatomic,copy) void (^gotoReplayControllerBlock)(void);

///分享
@property (nonatomic,copy) void (^gotoShareBlock)(BYControlModel *model);

@property (nonatomic,copy) void(^gotoAutoInstallBlock)(void);
@property(nonatomic,strong) BYControlModel * model;

@property(nonatomic,strong) NSString * address;

@property(nonatomic,assign) CGFloat distance;//我俩距离

@end
