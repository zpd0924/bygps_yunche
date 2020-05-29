//
//  BYEditShareCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYEditShareCell.h"
#import "BYEditPersonCell.h"
#import "BYPickView.h"
#import "BYShareCommitDeviceModel.h"
#import "BYAlertTip.h"
@interface BYEditShareCell()<UITableViewDelegate,UITableViewDataSource>
///车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

///车牌车型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
///车主
@property (weak, nonatomic) IBOutlet UILabel *carOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *devicesLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIButton *withoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *insideBtn;
@property (weak, nonatomic) IBOutlet UIView *insideLine;
@property (weak, nonatomic) IBOutlet UIView *withoutLine;

@property (weak, nonatomic) IBOutlet UITableView *personTableView;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personTableViewH;
@property (weak, nonatomic) IBOutlet UISwitch *commandBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareDateLabel;
@property (nonatomic,weak) UIViewController *cf_viewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carImageLineTopH;

@end
@implementation BYEditShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.personTableView.delegate = self;
    self.personTableView.dataSource = self;
    self.insideBtn.selected = YES;
    self.insideLine.hidden = NO;
    [self.personTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYEditPersonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BYEditPersonCell class])];
    self.commandBtn.onTintColor = BYGlobalBlueColor;
    self.alarmSwitchBtn.onTintColor = BYGlobalBlueColor;
    [self.dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateTap)]];
    
}
- (void)dateTap{
    [self selectDate];
}

//指令开关
- (IBAction)switchBtnClick:(UISwitch *)sender {
    if (sender.on) {
        _model.sendCommand = @"Y";
    }else{
        _model.sendCommand = @"N";
    }
  
}
//警报开关
- (IBAction)switchAlamBtnClick:(UISwitch *)sender {
    if (sender.on) {
        _model.checkAlarm = @"Y";
    }else{
        _model.checkAlarm = @"N";
    }
}

- (void)setModel:(BYShareListModel *)model{
    _model = model;
  
    self.carNumberLabel.text = [BYObjectTool carOrUserCellInfo:model];
    if (![BYObjectTool carOrUserCellInfo:model].length) {
        self.carImageLineTopH.constant = 20;
    }else{
        self.carImageLineTopH.constant = 8;
    }
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号:%@",model.carVin.length?model.carVin:@""];
    NSString *devicesStr = nil;
    for (int i = 0; i < model.deviceShare.count; i++) {
        BYShareCommitDeviceModel *deviceModel = model.deviceShare[i];
        if (devicesStr.length) {
             devicesStr = [NSString stringWithFormat:@"%@\n设备%d: %@(%@%@)",devicesStr,i+1,deviceModel.deviceSn,deviceModel.deviceModel,deviceModel.wifi == 0?@"有线":@"无线"];
        }else{
            devicesStr = [NSString stringWithFormat:@"设备%d: %@(%@%@)",i+1,deviceModel.deviceSn,deviceModel.deviceModel,deviceModel.wifi == 0?@"有线":@"无线"];
        }
       
    }
    self.devicesLabel.text = devicesStr;
    self.adressLabel.text = model.address.length?model.address:@"无";;
    self.shareDateLabel.text = model.shareTime;
    if (self.insideBtn.selected) {
         self.personTableViewH.constant = model.shareLine.count * 50;
    }else{
         self.personTableViewH.constant = model.shareMobile.count * 50;
    }
   
    self.alarmSwitchBtn.on = [_model.checkAlarm isEqualToString:@"Y"]?YES:NO;
    self.commandBtn.on = [_model.sendCommand isEqualToString:@"Y"]?YES:NO;
    
}
- (IBAction)insideBtnClick:(UIButton *)sender {
    self.insideBtn.selected = YES;
    self.insideLine.hidden = NO;
    self.withoutBtn.selected = NO;
    self.withoutLine.hidden = YES;
    self.personTableViewH.constant = _model.shareLine.count * 50;
   
    [self.personTableView reloadData];
    if (self.refreshShareBlock) {
        self.refreshShareBlock();
    }
    
}
- (IBAction)withoutBtnClick:(UIButton *)sender {
    self.insideBtn.selected = NO;
    self.insideLine.hidden = YES;
    self.withoutBtn.selected = YES;
    self.withoutLine.hidden = NO;

      self.personTableViewH.constant = _model.shareMobile.count * 50;
    [self.personTableView reloadData];
    if (self.refreshShareBlock) {
        self.refreshShareBlock();
    }
  
}

- (IBAction)sureBtn:(UIButton *)sender {
    if (self.editShareBlock) {
        self.editShareBlock(_model);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.insideBtn.selected) {
       return  _model.shareLine.count;
    }else{
       return _model.shareMobile.count;
    }
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    BYEditPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYEditPersonCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.deletPersonBlock = ^(BYShareUserModel *model) {
        [BYAlertTip ShowAlertWith:@"确定要删除该接收人吗？" message:nil withCancelTitle:@"取消" withSureTitle:@"确定" viewControl:self.cf_viewController andSureBack:^{
            if (weakSelf.insideBtn.selected) {
                [_model.shareLine removeObject:model];
            }else{
                [_model.shareMobile removeObject:model];
            }
            [weakSelf.personTableView reloadData];
            if (weakSelf.refreshShareBlock) {
                weakSelf.refreshShareBlock();
            }
        } andCancelBack:^{
            
        }];
       
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.insideBtn.selected) {
        cell.model = _model.shareLine[indexPath.row];
    }else{
        cell.model = _model.shareMobile[indexPath.row];
    }
    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- 日期选择
- (void)selectDate{
    NSDate *nextDay = [NSDate dateWithTimeInterval:6*24*60*60 sinceDate:[NSDate date]];//后一天
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:nextDay center:@"请选择日期" datePickerMode:UIDatePickerModeDate pickViewType:BYPickViewTypeDate];
    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最小时间
    datePicker.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 365 * 24 * 60 * 60]; // 设置最大时间
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        weakSelf.model.shareTime = [weakSelf formatterSelectDate:date];
        if (weakSelf.refreshShareBlock) {
            weakSelf.refreshShareBlock();
        }
    }];
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
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
