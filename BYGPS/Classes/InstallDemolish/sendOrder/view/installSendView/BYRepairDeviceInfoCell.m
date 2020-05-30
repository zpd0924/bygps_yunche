//
//  BYRepairDeviceInfoCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYRepairDeviceInfoCell.h"


@interface BYRepairDeviceInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *wifiOrWiredDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *chioceBtn;

@end

@implementation BYRepairDeviceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(BYDeviceModel *)model{
    _model = model;
    switch (model.deviceType) {
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
    self.deviceStatusLabel.text = model.deviceProvider;
    self.deviceNumberLabel.text = model.deviceSn;
    if (model.isSelect) {
        self.chioceBtn.selected = YES;
    }else{
        self.chioceBtn.selected = NO;
    }
}
- (IBAction)chioceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _model.isSelect = sender.selected;
    if (self.repairDeviceInfoBlock) {
        self.repairDeviceInfoBlock(_model);
    }
}

@end
