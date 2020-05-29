//
//  BYDeviceInfoCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYDeviceInfoCell.h"
#import "BYButton.h"
#import "BYPickView.h"

@interface BYDeviceInfoCell()
@property (weak, nonatomic) IBOutlet BYButton *deviceBtn;
@property (weak, nonatomic) IBOutlet BYButton *deviceStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addOrDeletBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;

@property (nonatomic,strong) NSArray *deviceArray;

@property (nonatomic,strong) NSArray *deviceStatusArray;
@end

@implementation BYDeviceInfoCell


- (void)setModel:(BYDeviceModel *)model{
    _model = model;
    [self.deviceBtn setTitle:model.deviceProvider forState:UIControlStateNormal];
    switch (model.deviceType) {//设备类型 0.有限设备 1.无线设备 3.其他设备
        case 0:
            [self.deviceStatusBtn setTitle:@"有线设备" forState:UIControlStateNormal];
            break;
        case 1:
            [self.deviceStatusBtn setTitle:@"无线设备" forState:UIControlStateNormal];
            break;
           
        default:
             [self.deviceStatusBtn setTitle:@"其他设备" forState:UIControlStateNormal];
            break;
    }
    if (!model.deviceCount) {
        self.countLabel.text = [NSString stringWithFormat:@"%d",1];
    }else{
         self.countLabel.text = [NSString stringWithFormat:@"%zd",model.deviceCount];
    }
   
    if (model.isAdd) {
        [self.addOrDeletBtn setImage:[UIImage imageNamed:@"device_add"] forState:UIControlStateNormal];
    }else{
        [self.addOrDeletBtn setImage:[UIImage imageNamed:@"device_minus"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)addOrDeletBtnClick:(UIButton *)sender {
    
    if (_model.isAdd) {
        if (self.addBlock) {
            self.addBlock(_model);
        }
    }else{
        if (self.minusBlock) {
            self.minusBlock(_model);
        }
    }
}
- (IBAction)addBtnClick:(UIButton *)sender {
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] + 1];
    _model.deviceCount = [self.countLabel.text integerValue];
    if (self.deviceCountAddOrMinusBlock) {
        self.deviceCountAddOrMinusBlock();
    }
}

- (IBAction)jianBtnClick:(UIButton *)sender {
    if ([self.countLabel.text integerValue] == 1) {
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] - 1];
    _model.deviceCount = [self.countLabel.text integerValue];
    if (self.deviceCountAddOrMinusBlock) {
        self.deviceCountAddOrMinusBlock();
    }
}

- (IBAction)choiceDeviceBtnClick:(BYButton *)sender {
    BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"设备选择" dataSource:self.deviceArray currentTitle:@"标越设备"];
    BYWeakSelf;
    [pickView setSurePickBlock:^(NSString *currentStr) {
    
        
        weakSelf.model.deviceProvider = currentStr;
        [weakSelf.deviceBtn setTitle:currentStr forState:UIControlStateNormal];
        
    }];

}
- (IBAction)choiceDeviceStatusBtnClick:(BYButton *)sender {
    BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"设备类型选择" dataSource:self.deviceStatusArray currentTitle:@"有线设备"];
    BYWeakSelf;
    [pickView setSurePickBlock:^(NSString *currentStr) {
        if ([currentStr isEqualToString:@"有线设备"]) {
            weakSelf.model.deviceType = 0;
        }else if ([currentStr isEqualToString:@"无线设备"]){
            weakSelf.model.deviceType = 1;
        }else{
            weakSelf.model.deviceType = 3;
        }
        
        [weakSelf.deviceStatusBtn setTitle:currentStr forState:UIControlStateNormal];
    }];
}

-(NSArray *)deviceArray
{
    if (!_deviceArray) {
        _deviceArray = @[@"标越设备",@"第三方设备"];
    }
    return _deviceArray;
}
-(NSArray *)deviceStatusArray
{
    if (!_deviceStatusArray) {
        _deviceStatusArray = @[@"有线设备",@"无线设备",@"其他设备"];
    }
    return _deviceStatusArray;
}


@end
