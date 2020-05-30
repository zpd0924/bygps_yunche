//
//  BYSelectDemolishController.h
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSelectDeviceController : UIViewController

@property(nonatomic,assign) BOOL isImages;

@property(nonatomic,strong) NSString * carNum;//用于直接从拆机进来该传的车牌号

@property(nonatomic,strong) NSString * ownerName;//用于直接从拆机进来该传的车主

@property (nonatomic,assign) NSInteger carId;

@property(nonatomic,strong) NSMutableArray * fillInfoArr;//用于拆机预约过来的数据信息

@end
