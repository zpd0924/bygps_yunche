//
//  BYKeepDetailWayCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDetailWayCell.h"

@interface BYKeepDetailWayCell()

@property (weak, nonatomic) IBOutlet UILabel *repairWayLabel;

@property (weak, nonatomic) IBOutlet UILabel *installLocationLabel;

@end
@implementation BYKeepDetailWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYDeviceModel *)model{
    _model = model;
    switch (model.repairScheme) {
        case 1:
            self.repairWayLabel.text = @"仅维修";
            break;
        case 2:
            self.repairWayLabel.text = @"设备更换";
            break;
        default:
            self.repairWayLabel.text = @"重新安装";
            break;
    }
    self.installLocationLabel.text = model.devicePosition;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
