//
//  BYMonthPayOffCell.h
//  BYGPS
//
//  Created by ZPD on 2018/6/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYMonthPayoffModel;
@interface BYMonthPayOffCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) BYMonthPayoffModel *payOffModel;

@property (nonatomic,copy) void(^chooseTimeBlock)(void);

@property (nonatomic,copy) void(^dayTextFieldEndEditBlock)(NSString *text);
@property (nonatomic,copy) void(^beforDayTextFieldEndEditBlock)(NSString *text);
@property (nonatomic,copy) void(^afterDayTextFieldEndEditBlock)(NSString *text);


@end
