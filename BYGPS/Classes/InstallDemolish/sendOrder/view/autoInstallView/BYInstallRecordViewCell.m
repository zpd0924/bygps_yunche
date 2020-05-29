//
//  BYInstallRecordViewCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallRecordViewCell.h"

@interface BYInstallRecordViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceCountLabel;



@end

@implementation BYInstallRecordViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYMyAllWorkOrderModel *)model{
    _model = model;
    self.orderSnLabel.text = model.orderNo;
    self.orderTimeLabel.text = model.createTime;
    self.deviceCountLabel.text = [NSString stringWithFormat:@"有线%zd 无线%zd 其他%zd",model.wirelineDeviceCount?model.wirelineDeviceCount:0,model.wirelessDeviceCount?model.wirelessDeviceCount:0,model.otherDeviceCount?model.otherDeviceCount:0];
}

@end
