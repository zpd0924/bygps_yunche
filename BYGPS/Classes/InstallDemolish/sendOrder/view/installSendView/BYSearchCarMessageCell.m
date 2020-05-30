//
//  BYSearchCarMessageCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/14.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSearchCarMessageCell.h"
#import "BYDeviceModel.h"
@interface BYSearchCarMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *carUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *devicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *relevanceLabel;


@end

@implementation BYSearchCarMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(BYSearchCarByNumOrVinModel *)model{
    _model = model;
    self.carNumberLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.carNum.length?model.carNum:@""];
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号:%@",model.carVin.length?model.carVin:@""];
    self.carUserLabel.text = [NSString stringWithFormat:@"车主:%@",model.ownerName.length?model.ownerName:@""];
    self.carModelLabel.text = [NSString stringWithFormat:@"车型:%@%@%@",model.brand.length > 0 ? model.brand : @"-",model.carType.length ? model.carType : @"",model.carModel.length?model.carModel:@""];
    NSString *devicesStr = nil;
    for (BYDeviceModel *devieceModel in model.list) {
        if (devicesStr.length == 0) {
            devicesStr = [NSString stringWithFormat:@"%@(%@)",devieceModel.deviceSn,devieceModel.deviceType?@"无线":@"有线"];
        }else{
            devicesStr = [NSString stringWithFormat:@"%@\n%@",devicesStr,[NSString stringWithFormat:@"%@(%@)",devieceModel.deviceSn,devieceModel.deviceType?@"无线":@"有线"]];
        }
    }
    self.devicesLabel.text = devicesStr;
    self.relevanceLabel.hidden = !devicesStr.length;
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.carMessageBlock) {
            self.carMessageBlock(_model);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
