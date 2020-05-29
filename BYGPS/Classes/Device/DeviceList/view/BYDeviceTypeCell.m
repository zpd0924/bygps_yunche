//
//  BYDeviceTypeCell.m
//  BYGPS
//
//  Created by miwer on 16/8/31.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceTypeCell.h"
#import "BYDeviceTypeModel.h"

@interface BYDeviceTypeCell ()

@property (weak, nonatomic) IBOutlet UIButton *deviceTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYDeviceTypeCell

-(void)setModel:(BYDeviceTypeModel *)model{
    
    self.deviceTypeButton.selected = model.isSelect;
    NSString * wifiStr = model.wifi ? @"无线" : @"有线";
    self.titleLabel.text = [NSString stringWithFormat:@"BY-%@ (%@)",model.alias,wifiStr];
}


@end
