//
//  BYAutoServiceDeviceRepairCheckCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRepairCheckCell.h"
#import "BYAutoDeviceRepairDeviceModel.h"

@interface BYAutoServiceDeviceRepairCheckCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation BYAutoServiceDeviceRepairCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(BYAutoDeviceRepairDeviceModel *)model{
    
    _model = model;
    if (model.repairCellType == BYRepairCellCheckInstallType) {
        self.titleLabel.text = @"查看旧的安装位置";
        self.subTitleLabel.hidden = YES;
    }else{
        self.titleLabel.text = @"新设备";
        self.subTitleLabel.hidden = NO;
        self.subTitleLabel.text = model.deviceSn.length > 0 ? [NSString stringWithFormat:@"新%@（%@%@）",model.deviceSn,model.alias,model.deviceType == 0 ? @"有线" : model.deviceType == 1 ? @"无线" : @"其他"] : @"";
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
