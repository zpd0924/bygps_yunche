//
//  BYReceiveShareCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/11.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYReceiveShareCell.h"
#import "BYShareDeviceTypeCell.h"
#import "BYShareListModel.h"
#import "BYDateFormtterTool.h"
#import "BYControlH5ViewController.h"
#import "BYPushNaviModel.h"
#import "BYControlViewController.h"

@interface BYReceiveShareCell()<UITableViewDelegate,UITableViewDataSource>
///分享日期
@property (weak, nonatomic) IBOutlet UILabel *shareDateLabel;
///有效日期
@property (weak, nonatomic) IBOutlet UIButton *residueDayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

///车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
///车牌车型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
///车主
@property (weak, nonatomic) IBOutlet UILabel *carOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *sharePersonLabel;

///设备列表
@property (weak, nonatomic) IBOutlet UITableView *deviceTabelView;
///设备列表的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceTabelViewH;

///备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *line1;

@property (weak, nonatomic) IBOutlet UIView *line2;
@property (nonatomic,weak) UIViewController *cf_viewController;
@end

@implementation BYReceiveShareCell

- (void)setModel:(BYShareListModel *)model{
    _model = model;
    self.shareDateLabel.text = model.createTime;
    [self.residueDayBtn setTitle:[NSString stringWithFormat:@"剩余%zd天",[BYDateFormtterTool getDiffDayWithDate:_model.shareTime]] forState:UIControlStateNormal];
  
    self.carNumberLabel.text = [BYObjectTool carOrUserCellInfo:model];
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号:%@",model.carVin.length?model.carVin:@""];
    self.sharePersonLabel.text = [NSString stringWithFormat:@"分享人:%@",model.shareUserName];
    self.remarkLabel.text = model.remark.length?model.remark:@" ";
    self.deviceTabelViewH.constant = model.deviceShare.count*50;
    if ([model.isEnd isEqualToString:@"Y"]) {//已过期
        [self timeOver];
    }else{
        [self timeGood];
    }
    [self.deviceTabelView reloadData];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.deviceTabelView.delegate = self;
    self.deviceTabelView.dataSource = self;
    self.deviceTabelViewH.constant = 200;
    [self.deviceTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([BYShareDeviceTypeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BYShareDeviceTypeCell class])];
    
}

#pragma mark -- 过期
- (void)setIsDated:(BOOL)isDated{
    _isDated = isDated;
    if (isDated) {
        [self timeOver];
    }
}

//过期颜色
- (void)timeOver{
    self.shareDateLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    [self.residueDayBtn setTitleColor:UIColorHexFromRGB(0xA9A9A9) forState:UIControlStateNormal];
    self.carImageView.image = [UIImage imageNamed:@"share_grayCar"];
    [self.residueDayBtn setImage:nil forState:UIControlStateNormal];
    [self.residueDayBtn setTitle:@"已过期" forState:UIControlStateNormal];
    self.carNumberLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    self.carTypeLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    self.carOwnerLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    [self.line1 setBackgroundColor:UIColorHexFromRGB(0xA9A9A9)];
    [self.line2 setBackgroundColor:UIColorHexFromRGB(0xA9A9A9)];
    self.carVinLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    self.sharePersonLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
    self.remarkLabel.textColor = UIColorHexFromRGB(0xA9A9A9);;
    self.remarkTitleLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
}
//正常颜色
- (void)timeGood{
    self.shareDateLabel.textColor = UIColorHexFromRGB(0x333333);
    [self.residueDayBtn setTitleColor:UIColorHexFromRGB(0x38986A) forState:UIControlStateNormal];
    self.carImageView.image = [UIImage imageNamed:@"share_circleCar"];
    [self.residueDayBtn setImage:[UIImage imageNamed:@"share_shijian"] forState:UIControlStateNormal];
    [self.residueDayBtn setTitle:[NSString stringWithFormat:@"剩余%zd天",[BYDateFormtterTool getDiffDayWithDate:_model.shareTime]] forState:UIControlStateNormal];
    self.carNumberLabel.textColor = UIColorHexFromRGB(0x333333);
    self.carTypeLabel.textColor = UIColorHexFromRGB(0x333333);
    self.carOwnerLabel.textColor = UIColorHexFromRGB(0x333333);
    [self.line1 setBackgroundColor:UIColorHexFromRGB(0x333333)];
    [self.line2 setBackgroundColor:UIColorHexFromRGB(0x333333)];
    self.carVinLabel.textColor = UIColorHexFromRGB(0x333333);
    self.sharePersonLabel.textColor = UIColorHexFromRGB(0x333333);
    self.remarkLabel.textColor = UIColorHexFromRGB(0x333333);;
    self.remarkTitleLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return _model.deviceShare.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    BYShareDeviceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYShareDeviceTypeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.isDated = _isDated;
    cell.model = _model.deviceShare[indexPath.row];
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isDated)return;
    BYControlViewController * controlVC = [[BYControlViewController alloc] init];
    controlVC.isNaviPush = YES;
    BYShareCommitDeviceModel *deviceModel = _model.deviceShare[indexPath.row];
    controlVC.deviceIdsStr = deviceModel.deviceId;
    controlVC.shareId = _model.shareId;
    [self.cf_viewController.navigationController pushViewController:controlVC animated:YES];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (UIViewController*)cf_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController * )nextResponder;
        }
    }
    return nil;
}
@end
