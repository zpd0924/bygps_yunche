//
//  BYCheckWorkOrderCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCheckWorkOrderCell.h"

@interface BYCheckWorkOrderCell()
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationStatusBtn;
@property (weak, nonatomic) IBOutlet UILabel *devieceSNLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookLocationBtn;



@end

@implementation BYCheckWorkOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYDeviceModel *)model{
    _model = model;
    self.deviceStatusTypeLabel.text = model.deviceProvider;
    switch (model.deviceType) {//设备类型 1.有限设备 2.无线设备 3.其他设备
        case 0:
            self.deviceStatusLabel.text = @"有线设备";
            break;
        case 1:
            self.deviceStatusLabel.text = @"无线设备";
            break;
        default:
            self.deviceStatusLabel.text = @"其他设备";
            break;
    }
    switch (model.status) {//0:不在线 1：在线
        case 1:
            [self.locationStatusBtn setTitle:@"离线" forState:UIControlStateNormal];
            [self.locationStatusBtn setImage:[UIImage imageNamed:@"notice_small"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.locationStatusBtn setTitle:@"上线不定位" forState:UIControlStateNormal];
            [self.locationStatusBtn setImage:[UIImage imageNamed:@"notice_small"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.locationStatusBtn setTitle:@"在线行驶" forState:UIControlStateNormal];
            [self.locationStatusBtn setImage:[UIImage imageNamed:@"sucess_small"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.locationStatusBtn setTitle:@"在线熄火" forState:UIControlStateNormal];
            [self.locationStatusBtn setImage:[UIImage imageNamed:@"sucess_small"] forState:UIControlStateNormal];
            break;
        default:
            [self.locationStatusBtn setTitle:@"报警" forState:UIControlStateNormal];
            [self.locationStatusBtn setImage:[UIImage imageNamed:@"notice_small"] forState:UIControlStateNormal];
            break;
    }
    self.devieceSNLabel.text = model.deviceSn;
    if (model.deviceType == 3) {
        self.lookLocationBtn.hidden = YES;
        self.locationStatusBtn.hidden = YES;
    }else{
        if (!model.deviceId) {
            self.lookLocationBtn.hidden = YES;
            self.locationStatusBtn.hidden = YES;
        }else{
            self.lookLocationBtn.hidden = NO;
            self.locationStatusBtn.hidden = NO;
        }
    }
    
}
//查看图片
- (IBAction)lookImagesBtnClick:(UIButton *)sender {
    if(self.lookImagesBlock)
        self.lookImagesBlock();
}

//查看定位
- (IBAction)lookLocationBtnClick:(UIButton *)sender {
    if (self.lookLocationBlock) {
        self.lookLocationBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
