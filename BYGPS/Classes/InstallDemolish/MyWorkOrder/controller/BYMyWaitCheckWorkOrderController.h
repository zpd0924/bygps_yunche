//
//  BYMyWaitCheckWorkOrderController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<待审核工单
#import <UIKit/UIKit.h>

typedef void(^BYMyWaitCheckWorkBlock)(NSInteger index);

@interface BYMyWaitCheckWorkOrderController : UITableViewController
@property (nonatomic,copy) BYMyWaitCheckWorkBlock myWaitCheckWorkBlock;
@end
