//
//  BYMyWorkOrderDetailSection4Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailSection4Cell.h"
@interface BYMyWorkOrderDetailSection4Cell()
@property (weak, nonatomic) IBOutlet UILabel *wifiOrWiredDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStausLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *szSameLabel;


@end
@implementation BYMyWorkOrderDetailSection4Cell

- (void)setDeviceModel:(BYDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    self.deviceStausLabel.text = deviceModel.deviceProvider;
    self.deviceNumberLabel.text = deviceModel.deviceSn;
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
    if (deviceModel.deviceType == 3) {
        self.locationStatusBtn.hidden = YES;
    }else{
        if (!deviceModel.deviceId) {
            self.locationStatusBtn.hidden = YES;
        }else{
            self.locationStatusBtn.hidden = NO;
        }
    }
    if (deviceModel.sameAdd == 0) {
        self.szSameLabel.hidden = YES;
    }else if (deviceModel.sameAdd == 1){
        self.szSameLabel.hidden = NO;
        self.szSameLabel.text = @"三址一致";
        self.szSameLabel.textColor = UIColorHexFromRGB(0x999999);
    }else{
        self.szSameLabel.hidden = NO;
        self.szSameLabel.text = @"三址不一致";
        self.szSameLabel.textColor = UIColorHexFromRGB(0xFF0000);
    }
   
    
}

- (IBAction)lookLocation:(UIButton *)sender {
    if (self.leftBtnBlock) {
        self.leftBtnBlock();
    }
}

- (IBAction)lookInstallImageBtnClick:(UIButton *)sender {
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
