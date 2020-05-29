//
//  BYReplayPopView.m
//  BYGPS
//
//  Created by miwer on 16/9/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYReplayPopView.h"
#import "BYReplayModel.h"
#import "NSString+BYAttributeString.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYReplayPopView ()

@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedOnlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation BYReplayPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAddressTap)];
    [self.addressLabel addGestureRecognizer:tap];
    self.addressLabel.userInteractionEnabled = YES;
}


-(void)getAddressTap{
    if (self.getAddressBlock) {
        self.getAddressBlock();
    }
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    self.addressLabel.text = address;
    self.model.pop_H = [self caculatePop_HWith:self.model];
}


-(void)setModel:(BYReplayModel *)model{
    _model = model;
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
        carNumStr = @"未装车";
    }
    
    NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:2];
    
    ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
    if (model.carId > 0) {
        self.carNumLabel.text = model.sn;
        self.ownerNameLabel.text = [NSString stringWithFormat:@"%@ %@",carNumStr,ownerNameStr];
        
    }else{
//        carNumStr = @"未装车";
        self.carNumLabel.text = [NSString stringWithFormat:@"[%@] %@",carNumStr,model.sn];
        self.ownerNameLabel.text = nil;
    }
//    NSString * carNumStr = model.carNum.length > 0 ? carNumStr : @"未装车";
    
    self.locationTimeLabel.text = [NSString stringWithFormat:@"定位时间:%@",model.gpsTime];
    self.speedOnlineLabel.text = [NSString stringWithFormat:@"是否定位:%@ 车辆速度:%@km/h",model.locate,model.speed];
    if ([self.deviceModel isEqualToString:@"G1-041W"]||[self.deviceModel isEqualToString:@"G2-042WF"]) {
        self.carStatusLabel.text = @"";
    }else{
        self.carStatusLabel.text = [NSString stringWithFormat:@"车辆状态:%@",model.status];
    }
    
    self.lastUpdateLabel.text = [NSString stringWithFormat:@"记录时间:%@",model.updateTime];
}

-(CGFloat)caculatePop_HWith:(BYReplayModel *)model{
    //先计算基础高度
    //上下间距 + 行间距 + 底部按钮 + 车牌label + 4 * 无线有线都有的label
    CGFloat base_H = BYS_W_H(130);
    
    CGFloat addressLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(160) Title:self.addressLabel.text font:13];
    
    CGFloat pop_H = base_H  + addressLabel_H;
    
    return pop_H;
}

@end
