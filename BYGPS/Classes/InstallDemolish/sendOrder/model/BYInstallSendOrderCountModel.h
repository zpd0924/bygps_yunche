//
//  BYInstallSendOrderCountModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYInstallSendOrderCountModel : JSONModel

///所有工单数量
@property (nonatomic,assign) NSInteger all;
///未接工单数量
@property (nonatomic,assign) NSInteger un;
///超时工单数量
@property (nonatomic,assign) NSInteger overtime;
///待审核工单数量
@property (nonatomic,assign) NSInteger isNotuditing;
@end
