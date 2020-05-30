//
//  BYKeepDetailDeviceCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDetailDeviceCell.h"
#import "BYButton.h"

@interface BYKeepDetailDeviceCell()

@property (weak, nonatomic) IBOutlet UILabel *wifiOrWiredDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;
@property (weak, nonatomic) IBOutlet BYButton *faultDescribeBtn;
@property (weak, nonatomic) IBOutlet UILabel *faultStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultDescribrLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faultStatusLabelWidthCons;


@end

@implementation BYKeepDetailDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDeviceModel:(BYDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    switch (deviceModel.deviceType) {///设备类型 1.有限设备 2.无线设备 3.其他设备
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
    self.deviceStatusLabel.text = deviceModel.deviceProvider;
    self.deviceNumberLabel.text= deviceModel.deviceSn;
    
    self.faultDescribrLabel.text = deviceModel.resonDetail;
    /// 1设备不上线、2 设备不定位、3 设备没电、4 其他
    switch (deviceModel.serviceReson) {
        case 1:
            self.faultStatusLabel.text = @"设备不上线";
            break;
        case 2:
            self.faultStatusLabel.text = @"设备不定位";
            break;
        case 3:
            self.faultStatusLabel.text = @"设备没电";
            break;
        default:
            self.faultStatusLabel.text = @"其他";
            break;
    }
    
    CGSize textSize = [self.faultStatusLabel.text boundingRectWithSize:CGSizeMake(MAXWIDTH - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    self.faultStatusLabelWidthCons.constant = textSize.width + 10;
    
}
- (IBAction)faultDescribeBtnClick:(BYButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
