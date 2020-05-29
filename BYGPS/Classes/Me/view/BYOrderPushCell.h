//
//  BYOrderPushCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYOrderPushModel.h"
typedef void(^OrderPushBlock)(NSInteger on);

@interface BYOrderPushCell : UITableViewCell
@property (nonatomic,copy) OrderPushBlock overTimeOrderBlock;
@property (nonatomic,copy) OrderPushBlock waitOrderBlock;
@property (nonatomic,copy) OrderPushBlock takeInOrderBlock;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,strong) BYOrderPushModel *model;
@end
