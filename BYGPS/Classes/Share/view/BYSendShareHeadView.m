//
//  BYSendShareHeadView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYSendShareHeadView.h"
#import "BYShareCommitDeviceModel.h"
@interface BYSendShareHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *carOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carImageLineTopH;

@end

@implementation BYSendShareHeadView

- (void)setParamModel:(BYShareCommitParamModel *)paramModel{
    _paramModel = paramModel;
    self.carNumLabel.text = [BYObjectTool carOrUserInfo:paramModel];
    if ([BYObjectTool carOrUserInfo:paramModel].length) {
        self.carImageLineTopH.constant = 8;
    }else{
        self.carImageLineTopH.constant = 20;
    }
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号: %@",paramModel.carVin.length?paramModel.carVin:@""];
    BYShareCommitDeviceModel *deviceModel = paramModel.deviceShare.firstObject;
    self.deviceSnLabel.text = [NSString stringWithFormat:@"设备号: %@(%@%@)",deviceModel.deviceSn,deviceModel.alias,deviceModel.deviceType == 0?@"有线":@"无线"];
    self.adressLabel.text = paramModel.address;
}

@end
