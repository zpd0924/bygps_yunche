//
//  BYAlarmPopView.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmPopView.h"
#import "BYAlarmModel.h"
#import "UILabel+BYCaculateHeight.h"
#import "NSString+BYAttributeString.h"

@interface BYAlarmPopView ()

@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmPositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleButton;
//@property (weak, nonatomic) IBOutlet UIButton *sponsorButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleButtonContraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelContraint_W;
@property (weak, nonatomic) IBOutlet UILabel *locationModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *separateAlarmLabel;
@property (weak, nonatomic) IBOutlet UILabel *separateAlarmDrtailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;

@end

@implementation BYAlarmPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.handleButtonContraint_H.constant = BYS_W_H(32);
    self.handleButton.layer.cornerRadius = BYS_W_H(32) / 2;
    self.addressLabelContraint_W.constant = BYS_W_H(140);
    self.handleButton.clipsToBounds = YES;
    self.locationTopConstraint.constant = 0;
    self.locationModelLabel.text = nil;
}

- (IBAction)presentAction:(id)sender {

    if (self.presentcBlock) {
        self.presentcBlock();
    }
}

-(void)setModel:(BYAlarmModel *)model{
    self.deviceNumLabel.text = model.sn;
    self.alarmTypeLabel.text = model.alarmName;
    self.carBrandLabel.text = model.carId > 0 ? [NSString stringWithFormat:@"车辆品牌:%@ %@",model.brand.length > 0 ? model.brand : @"" ,model.carType.length > 0 ? model.carType : @""] : @"";
    if([model.alarmName isEqualToString:@"多设备分离报警"]){
        self.separateAlarmDrtailLabel.text = [NSString stringWithFormat:@"与有线设备距离超过%@米",model.distance];
        self.separateAlarmDrtailLabel.attributedText = [BYObjectTool changeStrWittContext:self.separateAlarmDrtailLabel.text ChangeColorText:[NSString stringWithFormat:@"%@",model.distance] WithColor:[UIColor redColor] WithFont:[UIFont systemFontOfSize:13]];
        self.locationTopConstraint.constant = 0;
        self.locationModelLabel.text = nil;
    }else if([model.alarmName isEqualToString:@"定位分离报警"]){
        self.separateAlarmDrtailLabel.text = [NSString stringWithFormat:@"与其他定位模式距离超过%@米",model.distance];
        self.separateAlarmDrtailLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"与其他定位模式距离超过%@米",model.distance] ChangeColorText:[NSString stringWithFormat:@"%@",model.distance] WithColor:[UIColor redColor] WithFont:[UIFont systemFontOfSize:13]];
        self.locationTopConstraint.constant = 2;
        self.locationModelLabel.text = [NSString stringWithFormat:@"定位模式：%@",model.isGps ?  @"GPS" : @"基站"];
    }else{
        self.separateAlarmLabel.text = nil;
        self.separateAlarmDrtailLabel.text = nil;
        self.locationTopConstraint.constant = 0;
        self.locationModelLabel.text = nil;
    }
    self.alarmTimeLabel.text = [NSString stringWithFormat:@"报警时间: %@",model.createTime];
    
    NSString *carNumStr;
    if (model.carId > 0) {
        if (model.carNum.length > 0) {
            carNumStr = model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (model.carVin.length > 6) {
                NSRange range = NSMakeRange(model.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:range]];
            }else{
                carNumStr = model.carVin;
            }
        }
    }else{
        carNumStr = @"关联车辆:无关联车辆";
    }
//    NSString *carNumStr = [NSString StringJudgeIsValid:model.carNum isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
    NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
    
//    carNumStr = carNumStr.length > 8 ? [NSString stringWithFormat:@"%@...",[carNumStr substringToIndex:8]] : carNumStr;
    ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
    
//    self.carNumLabel.text = model.carNum.length ? [NSString stringWithFormat:@"关联车辆: %@ %@",carNumStr,ownerNameStr] : @"关联车辆:无关联车辆";
    self.carNumLabel.text = model.carId > 0 ?  [NSString stringWithFormat:@"关联车辆: %@ %@",carNumStr,ownerNameStr] : @"关联车辆:无关联车辆";
    if (![BYSaveTool boolForKey:BYAlarmsProcessKey]) {
        self.handleButton.hidden = YES;
    }else{
        self.handleButton.hidden = NO;
    }
   

    NSString * reasonStr = @"测试";
    switch (model.processingResult) {
        case 1: reasonStr = @"测试"; break;
        case 2: reasonStr = @"误报"; break;
        case 3: reasonStr = @"安装事故"; break;
        case 4: reasonStr = @"其他原因"; break;
    }
    
    NSString * title = @"处理报警";
    if (model.reviceTime.length) {
        title = model.processingUserId.length ? [NSString stringWithFormat:@"已处理(%@)",reasonStr] : @"已恢复";
    }else{
        title = model.processingUserId.length ? [NSString stringWithFormat:@"已处理(%@)",reasonStr] : @"处理报警";
    }
    [self.handleButton setTitle:title forState:UIControlStateNormal];
    
    model.pop_H = [self caculatePop_HWith:model];
}

-(CGFloat)caculatePop_HWith:(BYAlarmModel *)model{
    //先计算基础高度
    //上间距 + 行间距 + 车牌label + 现拍按钮上下间隔和高度
    
    CGFloat button_H = BYS_W_H(32) + 5 + 24;
    
    CGFloat base_H = BYS_W_H(20) +10 + 2*2+ BYS_W_H(16) * 3 + button_H;
    base_H = model.carId > 0 ? base_H : base_H - 16 - 2;
    //设备状态高度
//    CGFloat deviceStatus_H = [UILabel caculateLabel_HWith:BYS_W_H(155) Title:model.online font:13];
    CGFloat alarmDetailLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:self.separateAlarmDrtailLabel.text font:13];
    CGFloat addressLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:self.address font:13];
    
    CGFloat pop_H = base_H + addressLabel_H + alarmDetailLabel_H;
    if ([model.alarmName isEqualToString:@"定位分离报警"]) {
        pop_H = pop_H + 16 + 2;
    }
    
    
    BYLog(@"%f",pop_H);
    return pop_H;
}


-(void)setAddress:(NSString *)address{
    _address = address;
    self.alarmPositionLabel.text = address;
//    [self caculatePop_HWith:self.model];
}

-(void)setHandleType:(NSString *)handleType{
    if (handleType) {
        NSString * reasonStr = @"测试";
        switch ([handleType integerValue]) {
            case 1: reasonStr = @"测试"; break;
            case 2: reasonStr = @"误报"; break;
            case 3: reasonStr = @"安装事故"; break;
            case 4: reasonStr = @"其他原因"; break;
        }
        NSString * title = [NSString stringWithFormat:@"已处理(%@)",reasonStr];
        [self.handleButton setTitle:title forState:UIControlStateNormal];
    }
}

- (IBAction)alarmHandle:(id)sender {
    if (self.alarmHandelBlock) {
        self.alarmHandelBlock();
    }
}
- (IBAction)sponsorPhoto:(id)sender {
    
    if (self.sponsorPhotoBlock) {
        self.sponsorPhotoBlock(self.alarmPositionLabel.text);
    }
}

@end
