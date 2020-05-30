//
//  BYAutoServiceDeviceRepairReasonCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/21.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRepairReasonCell.h"
#import "BYAutoDeviceRepairDeviceModel.h"

@implementation BYAutoServiceDeviceRepairReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(BYAutoDeviceRepairDeviceModel *)model{
    _model = model;
    
    switch (model.serviceReson) {
        case 1:
            [self.reasonButton setTitle:@"设备不上线" forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.reasonButton setTitle:@"设备不定位" forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.reasonButton setTitle:@"设备没电" forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.reasonButton setTitle:@"其他" forState:UIControlStateNormal];
            break;
            
        default:
            [self.reasonButton setTitle:@"请选择" forState:UIControlStateNormal];
            break;
    }
    
}

- (IBAction)repairReasonClick:(id)sender {
    
    if (self.repairReasonTypeBlock) {
        self.repairReasonTypeBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
