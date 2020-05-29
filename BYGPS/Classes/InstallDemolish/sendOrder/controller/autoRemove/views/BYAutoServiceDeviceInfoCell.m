//
//  BYAutoServiceDeviceInfoCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceInfoCell.h"
#import "BYAutoServiceDeviceModel.h"


@interface BYAutoServiceDeviceInfoCell ()

@property (weak, nonatomic) IBOutlet UIButton *repairButton;


@end

@implementation BYAutoServiceDeviceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.repairButton.layer.cornerRadius = 5.0;
    self.repairButton.layer.masksToBounds = YES;
}

-(void)setFunctionType:(BYFunctionType)functionType{
    _functionType = functionType;
    [self.handleButton setTitle:functionType == BYFunctionTypeRemove ? @"拆机" : @"检修" forState:UIControlStateNormal];
}

-(void)setModel:(BYAutoServiceDeviceModel *)model{
    _model = model;
    
    self.deviceTypeImgView.image = [UIImage imageNamed:model.deviceType == 0 ? @"icon_autoService_device_eireline" : @"icon_autoService_device_eireless"];
    NSString *deviceModel = model.deviceId.length > 0 ? model.alias : @"";
    self.deviceSnLabel.text = [NSString stringWithFormat:@"%@（%@%@）",model.deviceSn,deviceModel,model.deviceType == 0 ? @"有线" : model.deviceType == 1 ? @"无线" : @"其他"];
    self.repairStateLabel.text = model.repaired ? (self.functionType == BYFunctionTypeRepair? @"已检修" : @"已拆机" ):(self.functionType == BYFunctionTypeRepair ? @"未检修": @"未拆机");
    self.deviceStatusLabel.text = model.deviceStatus;
    self.gpsTimeLabel.text = model.gpsTime;
    self.gpsAddressLabel.text = model.gpsAddress;
    
    [self.handleButton setTitle:self.functionType == BYFunctionTypeRemove ? (model.repaired ? @"修改/取消" : @"拆机") : (model.repaired ? @"修改/取消" : @"检修") forState:UIControlStateNormal];
    
}

- (IBAction)removeOrRepairClick:(UIButton *)sender {
    
    if (self.removeOrRepairBlock) {
        self.removeOrRepairBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
