//
//  BYAlarmConfigSwitchCell.h
//  BYGPS
//
//  Created by miwer on 2017/2/11.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYAlarmConfigModel;

@interface BYAlarmConfigSwitchCell : UITableViewCell

@property(nonatomic,strong) BYAlarmConfigModel * model;

@property(copy,nonatomic)void (^ switchOperation) ();

@end
