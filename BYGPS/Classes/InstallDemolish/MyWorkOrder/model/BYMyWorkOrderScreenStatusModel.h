//
//  BYMyWorkOrderScreenStatusModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYMyWorkOrderScreenStatusModel : JSONModel
///筛选条目名称
@property (nonatomic,strong) NSString *screenName;
///是否选中
@property (nonatomic,assign) BOOL isSelect;
///开始时间
@property (nonatomic,strong) NSString *starTime;
///结束时间
@property (nonatomic,strong) NSString *endTime;


///全部按钮是否选中
@property (nonatomic,assign) BOOL isAllBtnSelect;
///已完成按钮是否选中
@property (nonatomic,assign) BOOL isFinshBtnSelect;
///已完成超时按钮是否选中
@property (nonatomic,assign) BOOL isFinshOverTimeBtnSelect;
///已完成未超时按钮是否选中
@property (nonatomic,assign) BOOL isFinshNoOverTimeBtnSelect;
///未完成按钮是否选中
@property (nonatomic,assign) BOOL isNoFinishSelect;
///未完成超时按钮是否选中
@property (nonatomic,assign) BOOL isNoFinishOverTimeSelect;
///未完成未超时按钮是否选中
@property (nonatomic,assign) BOOL isNoFinishNoOverTimeSelect;
@end
