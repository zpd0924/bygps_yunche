//
//  BYKeepDetailFinshDeviceCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDetailFinshDeviceCell.h"

@interface BYKeepDetailFinshDeviceCell()

@property (weak, nonatomic) IBOutlet UILabel *wifiOrWiredDeviceLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceStautsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;

@end

@implementation BYKeepDetailFinshDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDeviceModel:(BYDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    switch (deviceModel.deviceType) {///设备类型 1.有限设备 2.无线设备 3.其他设备
        case 0:
            self.wifiOrWiredDeviceLabel.text = @"有线设备";
            break;
        case 1:
            self.wifiOrWiredDeviceLabel.text = @"无线设备";
            break;
        default:
            self.wifiOrWiredDeviceLabel.text = @"其他设备";
            break;
    }
    self.deviceStautsLabel.text = deviceModel.deviceProvider;
    self.deviceNumberLabel.text = deviceModel.newestSn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (IBAction)lookDetailBtnClick:(UIButton *)sender {
    if (self.detailFinshDeviceCellBlock) {
        self.detailFinshDeviceCellBlock();
    }
}

@end
