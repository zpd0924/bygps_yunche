//
//  BYAutoRepairDeviceSearchCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/25.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoRepairDeviceSearchCell.h"
#import "BYAutoServiceDeviceModel.h"

@interface BYAutoRepairDeviceSearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation BYAutoRepairDeviceSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addButton.layer.cornerRadius = 15;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.borderWidth = 1.0;
    self.addButton.layer.borderColor = UIColorHexFromRGB(0x0fa9f5).CGColor;
}

-(void)setDeviceModel:(BYAutoServiceDeviceModel *)deviceModel{
    
    _deviceModel = deviceModel;
    self.deviceImgView.image = [UIImage imageNamed:deviceModel.deviceType == 0 ? @"icon_autoService_device_eireline" : @"icon_autoService_device_eireless"];
    self.deviceTitleLabel.text = [NSString stringWithFormat:@"%@（%@%@）",self.deviceModel.deviceSn,self.deviceModel.alias,self.deviceModel.deviceType == 0 ? @"有线" : self.deviceModel.deviceType == 1 ? @"无线" : @"其他"];
    self.deviceStatusLabel.text = deviceModel.deviceStatus;
    self.gpsTimeLabel.text = deviceModel.gpsTime;
    self.gpsAddressLabel.text = deviceModel.gpsAddress;
}


- (IBAction)addDevice:(id)sender {
    
    if (self.addDeviceBlock) {
        self.addDeviceBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
