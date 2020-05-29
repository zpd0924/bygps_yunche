//
//  BYCarMessageSearchResultCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarMessageSearchResultCell.h"
#import "BYDeviceModel.h"

@interface BYCarMessageSearchResultCell()
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *carUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;

@property (weak, nonatomic) IBOutlet UILabel *devicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *relevanceLabel;

@end

@implementation BYCarMessageSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deletBtn.layer.cornerRadius = 3;
    self.deletBtn.layer.borderColor = BYsmallSpaceColor.CGColor;
    self.deletBtn.layer.borderWidth = 1;
    self.deletBtn.layer.masksToBounds = YES;
    // Initialization code
}
- (IBAction)delectBtnClick:(UIButton *)sender {
    if (self.delectBlock) {
        self.delectBlock();
    }
}
- (void)setModel:(BYSearchCarByNumOrVinModel *)model{
    _model = model;
    if(model.carNum.length == 0 || [model.carNum isKindOfClass:[NSNull class]]){
        self.carNumberLabel.hidden = YES;
    }else{
        self.carNumberLabel.hidden = NO;
        self.carNumberLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.carNum.length?model.carNum:@""];
    }
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号:%@",model.carVin.length?model.carVin:@""];
    self.carUserLabel.text = [NSString stringWithFormat:@"车主:%@",model.ownerName.length?model.ownerName:@""];
    if (model.brand.length == 0 && model.carType.length == 0 && model.carModel.length == 0) {
        self.carModelLabel.text = @"车型:-";
    }else{
        self.carModelLabel.text = [NSString stringWithFormat:@"车型:%@%@%@",model.brand.length ? model.brand : @"-",model.carType.length ? model.carType : @"",model.carModel.length?model.carModel:@""];
    }
    NSString *devicesStr = nil;
    for (BYDeviceModel *devieceModel in model.list) {
        if (devicesStr.length == 0) {
            devicesStr = [NSString stringWithFormat:@"%@(%@)",devieceModel.deviceSn,devieceModel.deviceType?@"无线":@"有线"];
            
        }else{
            devicesStr = [NSString stringWithFormat:@"%@\n%@",devicesStr, [NSString stringWithFormat:@"%@(%@)",devieceModel.deviceSn,devieceModel.deviceType?@"无线":@"有线"]];
        }
    }
    self.devicesLabel.text = devicesStr;
    self.relevanceLabel.hidden = !devicesStr.length;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end
