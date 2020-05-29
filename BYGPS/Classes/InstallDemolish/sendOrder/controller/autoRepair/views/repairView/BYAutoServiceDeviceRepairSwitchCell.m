//
//  BYAutoServiceDeviceRepairSwitchCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRepairSwitchCell.h"

#import "BYSwitchButtonView.h"

#import "BYAutoDeviceRepairDeviceModel.h"

@interface BYAutoServiceDeviceRepairSwitchCell ()
@property (weak, nonatomic) IBOutlet UIView *switchButtonView;


@property (nonatomic,strong) BYSwitchButtonView *buttonV;

@end


@implementation BYAutoServiceDeviceRepairSwitchCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buttonV = [[BYSwitchButtonView alloc] initWithItems:@[@"仅检修",@"更换设备",@"重新安装"]];
    self.buttonV.frame = CGRectMake(0, 0,kScreenWidth - 24, 35);
    [self.buttonV addTarget:self action:@selector(switchButtonTouch:)];
    [self.switchButtonView addSubview:self.buttonV];
    self.switchButtonView.layer.cornerRadius = 5.0;
    self.switchButtonView.layer.masksToBounds = YES;
}

-(void)setModel:(BYAutoDeviceRepairDeviceModel *)model{
    _model = model;
    self.buttonV.selectedIndex = model.repairType - 1;
}

-(void)switchButtonTouch:(UIButton *)button
{
    
    if (self.repairDeviceClickBlock) {
        self.repairDeviceClickBlock(button.tag - 3000 + 1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
