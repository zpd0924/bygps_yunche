//
//  BYInstallDeviceCheckViewCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallDeviceCheckViewCell.h"

@interface BYInstallDeviceCheckViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *deviceSnLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStautsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *fitLabel;

@end

@implementation BYInstallDeviceCheckViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(BYInstallDeviceCheckModel *)model{
    _model = model;
    self.deviceSnLabel.text = model.deviceSn.length?model.deviceSn:@"无";
    self.deviceGroupLabel.text = model.group.length?model.group:@"无";
    switch (model.deviceType) {
        case 0:
            self.deviceTypeLabel.text = @"有线设备";
            break;
        case 1:
             self.deviceTypeLabel.text = @"无线设备";
            break;
        case 3:
             self.deviceTypeLabel.text = @"其他设备";
            break;
        default:
            break;
    }
    switch (model.online) {
        case 0:
            self.deviceStautsLabel.text = @"离线";
            break;
        case 1:
            self.deviceStautsLabel.text = @"在线";
            break;
        default:
            self.deviceStautsLabel.text = @"离线";
            break;
    }
    self.lastTimeLabel.text = model.lastLocationTime.length?model.lastLocationTime:@"无";
    self.lastLocationLabel.text = model.deviceLocation.length?model.deviceLocation:@"无";
    if (model.isFit) {
        self.fitLabel.hidden = YES;
    }else{
        self.fitLabel.hidden = NO;
    }
}
- (IBAction)deletBtnClick:(UIButton *)sender {
    if (self.delectBlock) {
        self.delectBlock(_model);
    }
}

@end
