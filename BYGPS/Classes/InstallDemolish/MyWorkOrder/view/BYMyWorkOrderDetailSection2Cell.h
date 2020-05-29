//
//  BYMyWorkOrderDetailSection2Cell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYOrderDetailModel.h"

@interface BYMyWorkOrderDetailSection2Cell : UITableViewCell
@property (nonatomic,assign) BYSendOrderType sendOrderType;
@property (nonatomic,strong) BYOrderDetailModel *model;
@end
