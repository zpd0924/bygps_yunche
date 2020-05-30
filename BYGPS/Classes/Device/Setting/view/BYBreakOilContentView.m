//
//  BYBreakOilContentView.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBreakOilContentView.h"

@interface BYBreakOilContentView ()

@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;

@end

@implementation BYBreakOilContentView

-(void)setDeviceNum:(NSString *)deviceNum{
    
    self.deviceNumLabel.text = [NSString stringWithFormat:@"设备: %@",deviceNum];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end
