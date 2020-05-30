//
//  BYAutoServiceSearchDeviceCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/11.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceSearchDeviceCell.h"
#import "BYAutoServiceCarModel.h"

@interface BYAutoServiceSearchDeviceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *deviceImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;

@end

@implementation BYAutoServiceSearchDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCarModel:(BYAutoServiceCarModel *)carModel{
    _carModel = carModel;
    self.deviceImgView.image = [UIImage imageNamed:[carModel.deviceType integerValue] == 0?  @"icon_autoSearch_device_wireline" : @"icon_autoSearch_device_wireless"];
    self.deviceTitleLabel.text = [NSString stringWithFormat:@"%@（%@%@）",carModel.deviceSn,carModel.alias,[carModel.deviceType integerValue] == 0 ? @"有线" : @"无线"];

    self.carTitleLabel.text = [NSString stringWithFormat:@"%@  |  %@%@%@",[carModel.carNum isKindOfClass:[NSNull class]] ? @"-" : carModel.carNum.length == 0 ? @"-" : carModel.carNum,carModel.carBrand.length > 0 ? carModel.carBrand : @"",carModel.carType.length > 0 ? carModel.carType : @"",carModel.carColor];
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号：%@",carModel.carVin];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
