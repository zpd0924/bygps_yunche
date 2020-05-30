//
//  BYControlPopView.m
//  BYGPS
//
//  Created by miwer on 16/9/7.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYControlPopView.h"
#import "BYControlModel.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYControlPopView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBgViewContraintH;

@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStaLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locaTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSendLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAdressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailAdressLabelContraint_W;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceStatusContraint_W;
@property (weak, nonatomic) IBOutlet UILabel *sendDurationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;
@property (weak, nonatomic) IBOutlet UIButton *navigationBtn;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBtnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnW;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *shareLineView;
@property (weak, nonatomic) IBOutlet UIButton *autoInstallBtn;
@property (weak, nonatomic) IBOutlet UIView *autoInstallLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navgationLeftConstraintW;
@property (weak, nonatomic) IBOutlet UIButton *trackBtn;

@end

@implementation BYControlPopView

-(void)setAddress:(NSString *)address{
//    dispatch_async(dispatch_get_main_queue(), ^{
    _address = address;
    self.detailAdressLabel.text = address;
//    self.model.pop_H = [self caculatePop_HWith:self.model];
//    });
    
}

-(void)setModel:(BYControlModel *)model{
//    BYLog(@"%@",model);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _model = model;
        NSString * carNumStr = nil;
        if (model.ownerName.length >= 1) {
            carNumStr = model.carId > 0 ? [[BYSaveTool valueForKey:BYCarOwnerInfo] boolValue] ? model.ownerName :[NSString stringWithFormat:@"%@***",[model.ownerName.length>0?model.ownerName:@" " substringToIndex:1]] : @"未装车";
        }else{
            carNumStr = model.carId > 0 ? [[BYSaveTool valueForKey:BYCarOwnerInfo] boolValue] ? model.ownerName :@"" : @"未装车";
        }
      
        if (carNumStr.length > 4) {
            carNumStr = [carNumStr substringToIndex:4];
            self.carNumLabel.text = [NSString stringWithFormat:@"%@... %@",carNumStr,model.sn];
        }else{
            self.carNumLabel.text = [NSString stringWithFormat:@"%@  %@",carNumStr,model.sn];
        }
        self.carBrandLabel.text = model.carId > 0 ? [NSString stringWithFormat:@"车辆品牌:%@ %@",model.brand.length > 0 ? model.brand : @"",model.carType.length > 0 ? model.carType : @""] : @"";
        //    self.carNumLabel.text = [NSString stringWithFormat:@"%@ %@",carNumStr,model.sn];
        self.locaTimeLabel.text = [NSString stringWithFormat:@"定位时间: %@",model.gpsTime];
        self.positionModelLabel.text = [model.model containsString:@"026"] ? ([model.gpsModel isEqualToString:@"默认"] ? nil : [NSString stringWithFormat:@"定位模式: %@",model.gpsModel] ): nil;
        self.deviceStatusLabel.text = model.online;
        self.deviceModelLabel.text = [NSString stringWithFormat:@"设备型号：%@（%@）",model.alias,model.wifi ? @"无线" : @"有线"];
        /*
         车辆状态，无线设备先判断设备是否在线，不在线时不显示车辆状态。
         在线时，根据车辆的定位速度，但凡速度在0km以上，显示启动行驶+当前时速。速度是0则只显示 0km/h，不显示车辆启动怠速，因为无线设备无法确认车辆是熄火状态还是怠速状态。
         例1：车辆状态：启动行驶，速度：5km/h
         例2：车辆状态：速度0km/h
         
         
         1、当有线设备离线后，气泡中的“车辆状态”完全屏蔽，不在显示任何数据。
         2、当有线设备在线时车辆有停车时间上传时，车辆状态强制调整为 熄火
         3、如果有线设备既离线又有停车时长 ，则车辆状态也完全屏蔽
         
         有线设备 都显示车辆状态
         */
        
        if (!model.wifi) {//有线且启动
            self.carStaLabel.text = @"车辆状态:";
            self.carStatusLabel.text = [model.carStatus rangeOfString:@"启动行驶"].location != NSNotFound ? [NSString stringWithFormat:@"  %@ 速度:%.fkm/h",model.carStatus,model.speed] : [NSString stringWithFormat:@" %@",model.carStatus];
            if ([model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
                //            self.carStatusLabel.text = [model.carStatus rangeOfString:@"停车"].location != NSNotFound ? model.carStatus : [NSString stringWithFormat:@"  %@ 速度:%.fkm/h",model.carStatus,model.speed];
            }else{
                self.carStatusLabel.text = nil;
                self.carStaLabel.text = nil;
            }
            
        }else{
            
            if ([model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
                if ([self.model.model isEqualToString:@"G1-041W"] ||[self.model.model isEqualToString:@"G2-042WF"]) {
                    self.carStatusLabel.text = nil;
                    self.carStaLabel.text = nil;
                }else{
                    self.carStaLabel.text = @"车辆状态:";
                    self.carStatusLabel.text = model.speed > 0 ? [NSString stringWithFormat:@" 启动行驶 速度:%.fkm/h",model.speed] : [NSString stringWithFormat:@"速度: %.fkm/h",model.speed];
                }
                
            }else{
                self.carStatusLabel.text = nil;
                self.carStaLabel.text = nil;
            }
        }
        
        self.sendDurationTitleLabel.text = model.wifi ? ([model.intervalTime rangeOfString:@"月还款模式"].location != NSNotFound ? @"月还款模式:":@"发送间隔:") : nil;
        self.sendTimeLabel.text = model.wifi ? [NSString stringWithFormat:@"%@,剩余电量%@",model.intervalTime,model.batteryNotifier] : nil;
        self.lastSendLabel.text = [NSString stringWithFormat:@"最后上传: %@",model.updateTime];
    });
    model.pop_H = [self caculatePop_HWith:model];
    
    if (model.shareId.length) {
        if (model.carId > 0) {
            [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(BYS_W_H(245));
            }];
            _navgationLeftConstraintW.constant = 0;
            self.shareBtn.hidden = YES;
            self.shareLineView.hidden = YES;
        }else{
            [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(BYS_W_H(245/2));
            }];
            _navgationLeftConstraintW.constant = 0;
            [_autoInstallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(BYS_W_H(245/2));
            }];
            
            self.shareBtn.hidden = YES;
            self.shareLineView.hidden = YES;
            self.autoInstallBtn.hidden = NO;
            self.autoInstallLineView.hidden = NO;
        }
        
    }else{
        if ([BYSaveTool boolForKey:BYCarShareKey]) {
            if ([BYSaveTool boolForKey:BYAutoInstallOrder]&&model.carId == 0) {
                [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/3));
                }];
                [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/3));
                }];
                _navgationLeftConstraintW.constant = BYS_W_H(245/3);
                [_autoInstallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/3));
                }];
                
                self.shareBtn.hidden = NO;
                self.shareLineView.hidden = NO;
                self.autoInstallBtn.hidden = NO;
                self.autoInstallLineView.hidden = NO;
            }else{
                [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/2));
                }];
                [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/2));
                }];
                _navgationLeftConstraintW.constant = 0;
                [_autoInstallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
                
                self.shareBtn.hidden = NO;
                self.shareLineView.hidden = NO;
                self.autoInstallBtn.hidden = YES;
                self.autoInstallLineView.hidden = YES;
            }
           
        }else{
            if ([BYSaveTool boolForKey:BYAutoInstallOrder]&&model.carId == 0) {
                [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
                [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/2));
                }];
                _navgationLeftConstraintW.constant = 0;
                [_autoInstallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245/2));
                }];
                
                self.shareBtn.hidden = YES;
                self.shareLineView.hidden = YES;
                self.autoInstallBtn.hidden = NO;
                self.autoInstallLineView.hidden = NO;
            }else{
                [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
                [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(BYS_W_H(245));
                }];
                _navgationLeftConstraintW.constant = 0;
                [_autoInstallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(0);
                }];
                
                self.shareBtn.hidden = YES;
                self.shareLineView.hidden = YES;
                self.autoInstallBtn.hidden = YES;
                self.autoInstallLineView.hidden = YES;
            }
//            [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(0);
//            }];
//            [_navigationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(BYS_W_H(245));
//            }];
//            self.shareBtn.hidden = YES;
//            self.shareLineView.hidden = YES;
        }
    }
   
}

-(CGFloat)caculatePop_HWith:(BYControlModel *)model{
    //先计算基础高度
    //上下间距 + 行间距 + 底部按钮 + 车牌label + 4 * 无线有线都有的label
    CGFloat base_H = BYS_W_H(10) + 5 * BYS_W_H(2) + BYS_W_H(70) + BYS_W_H(20) + 5 * BYS_W_H(16) + 24;//144
    base_H = model.carId > 0 ? base_H : base_H - 16 - 2;
    //设备状态高度
    CGFloat deviceStatus_H = [UILabel caculateLabel_HWith:BYS_W_H(155) Title:model.online font:12];
    CGFloat addressLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(155) Title:self.address font:12];
    CGFloat pop_H = base_H + deviceStatus_H + addressLabel_H;
    

    if (model.wifi) {//无线
        //发送间隔高度
//        NSString * durationStr = [NSString stringWithFormat:@"%@,剩余电量%@",model.sengGrpTime,model.batteryNotifier];
        CGFloat duration_H = [UILabel caculateLabel_HWith:BYS_W_H(146) Title:self.sendTimeLabel.text font:12];
        
        CGFloat position_H = [model.model containsString:@"026"] ? ([model.gpsModel isEqualToString:@"默认"] ? 0 : BYS_W_H(16)) : 0;
        
        if ([model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
            //车辆状态 + 发送间隔
            CGFloat carSta_H = [UILabel caculateLabel_HWith:BYS_W_H(146) Title:self.carStatusLabel.text font:12];
            pop_H = pop_H + carSta_H + duration_H + position_H;
        }else{
            //发送间隔
            pop_H = pop_H + duration_H + position_H;
        }
    }else{//有线
        //车辆状态
        CGFloat carSta_H = [UILabel caculateLabel_HWith:BYS_W_H(146) Title:self.carStatusLabel.text font:12];
        pop_H = pop_H + carSta_H;
    }
    return pop_H;
}

-(void)setDistance:(CGFloat)distance{
    if (distance != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.distanceLabel.text = distance >= 1000 ? [NSString stringWithFormat:@"我俩距离: %.2fkm",distance / 1000] : [NSString stringWithFormat:@"我俩距离: %.1fm",distance];
        });  
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.buttonsBgViewContraintH.constant = BYS_W_H(70);
    self.detailAdressLabelContraint_W.constant = BYS_W_H(140);
    self.deviceStatusContraint_W.constant = BYS_W_H(155);

//    self.trackBtn.hidden = ![BYSaveTool boolForKey:BYMonitorTrackKey];
   
}

//设备信息
- (IBAction)deviceDetailAction:(UIButton *)sender {
    
    if (self.deviceDetailBlcok) {
        self.deviceDetailBlcok(sender.tag - 50);
    }
}
- (IBAction)gotoReplayBlock:(id)sender {
    if (self.gotoReplayControllerBlock) {
        self.gotoReplayControllerBlock();
    }
}

//删除气泡
- (IBAction)dismiss:(id)sender {
    if (self.dismissBlcok) {
        self.dismissBlcok();
    }
}
- (IBAction)gotoBaiduMap:(id)sender {
    if (self.gotoBaiduMapBlock) {
        self.gotoBaiduMapBlock();
    }
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    if (self.gotoShareBlock) {
        _model.adress = _address;
        self.gotoShareBlock(_model);
    }
}

- (IBAction)autoInstall:(UIButton *)sender {
    
    if (self.gotoAutoInstallBlock) {
        self.gotoAutoInstallBlock();
    }
}


@end
