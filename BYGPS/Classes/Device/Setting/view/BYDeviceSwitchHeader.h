//
//  BYDeviceSwitchHeader.h
//  BYGPS
//
//  Created by miwer on 16/7/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDeviceSwitchHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@property(copy,nonatomic)void (^ switchOperation) (BOOL isOn);


@end
