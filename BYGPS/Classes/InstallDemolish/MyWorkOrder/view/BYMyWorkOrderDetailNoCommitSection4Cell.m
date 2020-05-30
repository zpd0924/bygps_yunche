//
//  BYMyWorkOrderDetailNoCommitSection4Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailNoCommitSection4Cell.h"
@interface BYMyWorkOrderDetailNoCommitSection4Cell()
@property (weak, nonatomic) IBOutlet UILabel *wifiOrWriedDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookImageBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;


@end
@implementation BYMyWorkOrderDetailNoCommitSection4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDeviceModel:(BYDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    self.deviceStatusLabel.text = deviceModel.deviceProvider;
    if (deviceModel.removed == 1) {
        self.deviceNumberLabel.text = [NSString stringWithFormat:@"%@(%@)",deviceModel.deviceSn,@"成功"];
        self.deviceNumberLabel.attributedText = [BYObjectTool changeStrWittContext:self.deviceNumberLabel.text ChangeColorText:@"(成功)" WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:15]];
    }else if (deviceModel.removed == 2){
        self.deviceNumberLabel.text = [NSString stringWithFormat:@"%@(%@)",deviceModel.deviceSn,@"失败"];
        self.deviceNumberLabel.attributedText = [BYObjectTool changeStrWittContext:self.deviceNumberLabel.text ChangeColorText:@"(失败)" WithColor:[UIColor redColor] WithFont:[UIFont systemFontOfSize:15]];
    }
    else{
        self.deviceNumberLabel.text = deviceModel.deviceSn;
    }
    
    switch (deviceModel.deviceType) {///设备类型 1.有限设备 2.无线设备 3.其他设备
        case 0:
            self.wifiOrWriedDeviceLabel.text = @"有线设备";
            break;
        case 1:
            self.wifiOrWriedDeviceLabel.text = @"无线设备";
            break;
        default:
            self.wifiOrWriedDeviceLabel.text = @"其他设备";
            break;
    }
    if (deviceModel.NewDeviceVinImg.length) {
        self.lookImageBtn.hidden = NO;
        self.heightCons.constant = 38;
    }else{
        self.lookImageBtn.hidden = YES;
        self.heightCons.constant = 0;
    }
   
}
- (IBAction)lookImageBtnClick:(UIButton *)sender {
    
    if (self.lookImageBlock) {
        self.lookImageBlock(_deviceModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
