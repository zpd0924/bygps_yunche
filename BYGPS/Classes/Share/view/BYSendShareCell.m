//
//  BYSendShareCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYSendShareCell.h"
#import "BYShareCommitDeviceModel.h"
@interface BYSendShareCell()
@property (weak, nonatomic) IBOutlet UILabel *leftSmallLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBigLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *placeArr;
@end

@implementation BYSendShareCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.switchBtn.onTintColor = BYGlobalBlueColor;
   
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    BYShareCommitDeviceModel *deviceModel = _paramModel.deviceShare[_indexPath.row+1];
    deviceModel.isSelect = sender.selected;
}

//指令开关
- (IBAction)commandBtnClick:(UISwitch *)sender {
    if (_indexPath.row == 0) {
        if (sender.on) {
            _paramModel.sendCommand = @"Y";
        }else{
            _paramModel.sendCommand = @"N";
        }
    }else{
        if (sender.on) {
            _paramModel.checkAlarm = @"Y"; 
        }else{
            _paramModel.checkAlarm = @"N";
        }
    }
   
}



- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
   
    switch (indexPath.section) {
        case 0:
        {
            self.leftSmallLabel.hidden = NO;
            self.leftBigLabel.hidden = YES;
            self.deviceMessageLabel.hidden = NO;
            self.selectBtn.hidden = NO;
            self.moreImageView.hidden = YES;
            self.rightInfoLabel.hidden = YES;
            self.switchBtn.hidden = YES;
            //赋值
            BYShareCommitDeviceModel *deviceModel = _paramModel.deviceShare[indexPath.row + 1];
            self.selectBtn.selected = deviceModel.isSelect;
            self.leftSmallLabel.text = [NSString stringWithFormat:@"设备%zd:",indexPath.row+1];
            self.deviceMessageLabel.text = [NSString stringWithFormat:@"%@(%@%@)",deviceModel.deviceSn.length?deviceModel.deviceSn:@"",deviceModel.alias.length?deviceModel.alias:@"",deviceModel.deviceType == 0?@"有线":@"无线"];
        }
            break;
        case 1:
        {
            self.leftBigLabel.text = self.titleArr[indexPath.section][indexPath.row];
            self.rightInfoLabel.text = self.placeArr[indexPath.section][indexPath.row];
            self.leftSmallLabel.hidden = YES;
            self.leftBigLabel.hidden = NO;
            self.deviceMessageLabel.hidden = YES;
            self.selectBtn.hidden = YES;
            self.moreImageView.hidden = NO;
            self.rightInfoLabel.hidden = NO;
            self.switchBtn.hidden = YES;
            //赋值
            if (_indexPath.row == 0) {//内部员工
                if (_paramModel.shareLine.count) {
                    self.rightInfoLabel.text = [NSString stringWithFormat:@"%zd",_paramModel.shareLine.count];
                }
            }else{//外部员工
                if (_paramModel.shareMobile.count) {
                    self.rightInfoLabel.text = [NSString stringWithFormat:@"%zd",_paramModel.shareMobile.count];
                }
            }
           
            
            
        }
            break;
        default:
        {
            self.leftBigLabel.text = self.titleArr[indexPath.section][indexPath.row];
            self.rightInfoLabel.text = self.placeArr[indexPath.section][indexPath.row];
            self.leftSmallLabel.hidden = YES;
            self.leftBigLabel.hidden = NO;
            self.deviceMessageLabel.hidden = YES;
           
            if (indexPath.row == 0 || indexPath.row == 1) {
                self.selectBtn.hidden = YES;
                self.moreImageView.hidden = YES;
                self.rightInfoLabel.hidden = YES;
                self.switchBtn.hidden = NO;
                //赋值
                self.switchBtn.on = _paramModel.sendCommand;
            }else {
                self.selectBtn.hidden = YES;
                self.moreImageView.hidden = NO;
                self.rightInfoLabel.hidden = NO;
                self.switchBtn.hidden = YES;
                //赋值
                self.rightInfoLabel.text = _paramModel.shareTime;
            }
        }
            break;
    }
    
}
- (void)setParamModel:(BYShareCommitParamModel *)paramModel{
    _paramModel = paramModel;
    
    
}
-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"",@""],@[@"内部员工",@"外部人员"],@[@"允许发指令",@"允许报警配置",@"有效截止日期"]];
    }
    return _titleArr;
}
-(NSArray *)placeArr
{
    if (!_placeArr) {
        _placeArr = @[@[@"",@""],@[@"",@""],@[@"",@"",@"请选择有效日期"]];
    }
    return _placeArr;
}

@end
