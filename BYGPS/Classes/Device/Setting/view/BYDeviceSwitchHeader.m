//
//  BYDeviceSwitchHeader.m
//  BYGPS
//
//  Created by miwer on 16/7/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceSwitchHeader.h"

@implementation BYDeviceSwitchHeader

- (IBAction)switchOpreation:(id)sender {

    if (self.switchOperation) {
        self.switchOperation(self.switchView.isOn);
    }
}

//-(void)awakeFromNib{
//    [super awakeFromNib];
//    
//    [self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
//}
//
//-(void)switchValueChanged:(UISwitch *)switchView{
//    if (self.switchOperation) {
//        self.switchOperation(self.switchView.isOn);
//    }
//}

@end
