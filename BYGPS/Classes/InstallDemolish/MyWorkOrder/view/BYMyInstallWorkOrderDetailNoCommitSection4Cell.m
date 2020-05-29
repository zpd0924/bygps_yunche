//
//  BYMyInstallWorkOrderDetailNoCommitSection4Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyInstallWorkOrderDetailNoCommitSection4Cell.h"
@interface BYMyInstallWorkOrderDetailNoCommitSection4Cell()
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceWifiLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceProviderLabel;


@end
@implementation BYMyInstallWorkOrderDetailNoCommitSection4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDeviceModel:(BYDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    self.deviceStatusLabel.text = deviceModel.deviceProvider;
    switch (deviceModel.deviceType) {///设备类型 1.有限设备 2.无线设备 3.其他设备
        case 0:
            self.deviceWifiLabel.text = [NSString stringWithFormat:@"有线设备x%zd",deviceModel.deviceCount];
            break;
        case 1:
             self.deviceWifiLabel.text = [NSString stringWithFormat:@"无线设备x%zd",deviceModel.deviceCount];
            break;
        default:
             self.deviceWifiLabel.text = [NSString stringWithFormat:@"其他设备x%zd",deviceModel.deviceCount];
            break;
    }
    self.deviceProviderLabel.text = deviceModel.deviceProvider;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
