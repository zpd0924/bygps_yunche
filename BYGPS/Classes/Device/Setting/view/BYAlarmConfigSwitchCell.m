//
//  BYAlarmConfigSwitchCell.m
//  BYGPS
//
//  Created by miwer on 2017/2/11.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYAlarmConfigSwitchCell.h"
#import "BYAlarmConfigModel.h"

@interface BYAlarmConfigSwitchCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation BYAlarmConfigSwitchCell

-(void)setModel:(BYAlarmConfigModel *)model{
    self.titleLabel.text = model.alarmConfigTitle;
    self.switchView.on = model.alarmConfigValue;
}

- (IBAction)switchOperation:(UISwitch *)sender {
    
    if (self.switchOperation) {
        self.switchOperation();
    }
}

@end
