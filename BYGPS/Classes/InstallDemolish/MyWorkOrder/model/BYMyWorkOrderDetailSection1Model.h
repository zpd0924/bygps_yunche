//
//  BYMyWorkOrderDetailSection1Model.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYMyWorkOrderDetailSection1Model : NSObject
///是否隐藏topView
@property (nonatomic,assign) BOOL isHiddenTopView;
///是否隐藏topView
@property (nonatomic,assign) BOOL isHiddenBottomView;
///标题
@property (nonatomic,strong) NSString *titleStr;
///日期
@property (nonatomic,strong) NSString *dateStr;
///图片
@property (nonatomic,strong) NSString *imageStr;
@end
