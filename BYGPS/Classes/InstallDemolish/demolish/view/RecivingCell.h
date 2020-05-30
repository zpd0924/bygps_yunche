//
//  RecivingCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYReceivingModel;

@interface RecivingCell : UITableViewCell

@property(nonatomic,strong) BYReceivingModel * model;

@property(copy,nonatomic)void (^callBlcok) ();

@property(copy,nonatomic)void (^leftActionBlcok) ();

@property(copy,nonatomic)void (^rightActionBlcok) (BOOL isCancel);

@end
