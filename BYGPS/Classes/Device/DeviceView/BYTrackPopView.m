//
//  BYTrackPopView.m
//  BYGPS
//
//  Created by miwer on 16/9/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYTrackPopView.h"
#import "BYTrackModel.h"
#import "UILabel+BYCaculateHeight.h"
#import "NSString+BYAttributeString.h"

@interface BYTrackPopView ()

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStaLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailAdressLabelContraint_W;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendDurationTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceStatusContraint_W;
//@property (weak, nonatomic) IBOutlet UIButton *sponsorButton;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorButton_H;
@property (weak, nonatomic) IBOutlet BYUnderlineButtonView *headButtonView;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;

@property (nonatomic,strong) BYUnderlineButtonView *buttonView;


@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;

@end

@implementation BYTrackPopView

-(void)setModel:(BYTrackModel *)model{

//    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *carNumStr;
        if (model.carId > 0) {
            self.carBrandLabel.text = [NSString stringWithFormat:@"车辆品牌:%@ %@",model.carBrand.length?model.carBrand:@"",model.carType.length?model.carType:@""];
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
            carNumStr = [[BYSaveTool valueForKey:BYCarOwnerInfo] boolValue] ? model.ownerName.length>0?model.ownerName:@" " :[NSString stringWithFormat:@"%@***",[model.ownerName substringToIndex:1]];
        }else{
            self.carBrandLabel.text = @"";
            carNumStr = @"未装车";
        }
        if (carNumStr.length > 4) {
            carNumStr = [carNumStr substringToIndex:4];
            self.carNumLabel.text = [NSString stringWithFormat:@"%@... %@",carNumStr,model.sn];
        }else{
            self.carNumLabel.text = [NSString stringWithFormat:@"%@ %@",carNumStr,model.sn];
        }
        self.locationTimeLabel.text = [NSString stringWithFormat:@"定位时间: %@",model.gpsTime];
        self.positionModelLabel.text = [model.model containsString:@"026"] ? ([model.gpsModel isEqualToString:@"默认"] ? nil : [NSString stringWithFormat:@"定位模式：%@",model.gpsModel] ): nil;
      
        if (!model.wifi) {//有线且启动
            //        dispatch_async(dispatch_get_main_queue(), ^{
            self.carStaLabel.text = @"车辆状态";
            self.carStatusLabel.text = [model.carStatus rangeOfString:@"启动行驶"].location != NSNotFound ? [NSString stringWithFormat:@"%@ 速度:%.fkm/h",model.carStatus,model.speed] : [NSString stringWithFormat:@"%@",model.carStatus.length > 0 ? model.carStatus : @"无"];
            
            if ([model.online rangeOfString:@"离线"].location == NSNotFound){
                if ([self.model.model isEqualToString:@"G1-041W"]||[self.model.model isEqualToString:@"G2-042WF"]) {
                    self.carStatusLabel.text = nil;
                    self.carStaLabel.text = nil;
                }
                //            self.carStatusLabel.text = [model.carStatus rangeOfString:@"停车"].location != NSNotFound ? model.carStatus : [NSString stringWithFormat:@"  %@ 速度:%.fkm/h",model.carStatus,model.speed];
            }else{
                self.carStatusLabel.text = nil;
                self.carStaLabel.text = nil;
            }
            
            
            //        });
            
        }else{
            if ([model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.model.model isEqualToString:@"G1-041W"]||[self.model.model isEqualToString:@"G2-042WF"]) {
                        self.carStatusLabel.text = nil;
                        self.carStaLabel.text = nil;
                    }else{
                        self.carStaLabel.text = @"车辆状态:";
                        self.carStatusLabel.text = model.speed > 0 ? [NSString stringWithFormat:@"启动行驶 速度:%.fkm/h",model.speed] : [NSString stringWithFormat:@"速度:%.fkm/h",model.speed];
                    }
                    
                });
                
            }else{
                self.carStatusLabel.text = nil;
                self.carStaLabel.text = nil;
            }
        }
        
        self.deviceStatusLabel.text = model.online;
        
    self.sendDurationTitleLabel.text = model.wifi ? ([model.intervalTime rangeOfString:@"月还款模式"].location != NSNotFound ? @"月还款模式:":@"发送间隔:") : nil;
        self.sendTimeLabel.text = model.wifi ? [NSString stringWithFormat:@"%@,剩余电量%@",model.intervalTime,model.batteryNotifier] : nil;
        
        self.lastUpdateLabel.text = [NSString stringWithFormat:@"最后上传: %@",model.updateTime];
    self.deviceModelLabel.text = [NSString stringWithFormat:@"设备型号：%@（%@）",model.alias,model.wifi ? @"无线":@"有线"];
//    });
    
    model.pop_H = [self caculatePop_HWith:model];
}

-(CGFloat)caculatePop_HWith:(BYTrackModel *)model{
    //先计算基础高度
    //上下间距 + 行间距 + 车牌label + 4 * 无线有线都有的label + 现拍按钮上下间隔和高度
    
    CGFloat button_H = BYS_W_H(30) + 10 + BYS_W_H(40);
    
    CGFloat base_H = 10*2 + 2*5 + BYS_W_H(20) + 4 *BYS_W_H(16) + button_H + 24;//144
    base_H = model.carId > 0 ? base_H : base_H - 16 - 2;
    //设备状态高度
    CGFloat deviceStatus_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:self.deviceStatusLabel.text font:13];
    
    CGFloat addressLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:self.detailAddressLabel.text font:13];
    
    CGFloat carSta_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:self.carStatusLabel.text font:13];
    
    CGFloat pop_H = base_H + deviceStatus_H + addressLabel_H + 2 * 2;
    
    if (model.wifi) {//无线
        //发送间隔高度
        CGFloat duration_H = [UILabel caculateLabel_HWith:BYS_W_H(140) Title:model.wifi ? [NSString stringWithFormat:@"%@,剩余电量%@",model.intervalTime,model.batteryNotifier] : nil font:BYS_W_H(13)];
        
        CGFloat position_H = [model.model containsString:@"026"] ? ([model.gpsModel isEqualToString:@"默认"] ? 0 : BYS_W_H(16)) : 0;
        
        if ([model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
            //  发送间隔
            pop_H = pop_H + BYS_W_H(16) + duration_H  + position_H + 2*3;
        }else{
            //发送间隔
            pop_H += duration_H + position_H + 2 * 2;
        }
    }else{//有线
        //车辆状态
        pop_H += carSta_H + 2;
    }
    BYLog(@"%f",pop_H);
    return pop_H;
}


-(void)setAddress:(NSString *)address{
    _address = address;
    self.detailAddressLabel.text = address;
    self.model.pop_H = [self caculatePop_HWith:self.model];
}
-(void)setSubAddress:(NSString *)subAddress
{
    if ([self.detailAddressLabel.text isEqualToString:@"无法获取当前位置"]) {
        self.detailAddressLabel.text = subAddress;
    }
}
-(void)setDistance:(CGFloat)distance{
    
    self.distanceLabel.text = distance >= 1000 ? [NSString stringWithFormat:@"我俩距离: %.2fkm",distance / 1000] : [NSString stringWithFormat:@"我俩距离: %.1fm",distance];
}
- (IBAction)dismiss:(id)sender {
    if (self.dismissBlcok) {
        self.dismissBlcok();
    }
}
- (IBAction)sponsorPhoto:(id)sender {
    
    if (self.sponsorPhotoBlock) {
        self.sponsorPhotoBlock(self.detailAddressLabel.text);
    }
}
- (IBAction)gotoBaiduMap:(id)sender {
    if (self.gotoBaiduMapBlock) {
        self.gotoBaiduMapBlock();
    }
}
- (IBAction)gotoReplayController:(id)sender {
    
    if (self.gotoReplayBlock) {
        self.gotoReplayBlock();
    }
}

-(void)locationChangeAction:(UIButton *)sender {
    //60:GPS  61:基站 62.WIFI 
    if (self.getLocationChangeBlock) {
        self.getLocationChangeBlock(sender.tag - 1000 + 1);
    }
    
}

-(void)setButtonItems:(NSArray *)buttonItems{
    _buttonItems = buttonItems;
    self.buttonView = [[BYUnderlineButtonView alloc] initWithItems:buttonItems];
    self.buttonView.frame = CGRectMake(0, 0, BYS_W_H(210), BYS_W_H(40));
    [self.headButtonView addSubview:self.buttonView];
    [self.buttonView addTarget:self action:@selector(locationChangeAction:)];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.buttonView.selectedIndex = selectedIndex;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.deviceStatusContraint_W.constant = BYS_W_H(155);
    self.detailAdressLabelContraint_W.constant = BYS_W_H(140);
}

@end
