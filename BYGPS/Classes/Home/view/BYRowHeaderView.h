//
//  BYItemHeaderView.h
//  BYGPS
//
//  Created by miwer on 16/9/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYAlarmModel;

@interface BYRowHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong) BYAlarmModel * model;

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property(nonatomic,copy) void (^selectRowBlock) ();
@property(nonatomic,copy) void (^selectHeadBlock) ();//点击header的选中按钮

@end
