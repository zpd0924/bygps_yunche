//
//  BYParkPopView.m
//  BYGPS
//
//  Created by ZPD on 2017/8/21.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYParkPopView.h"
#import "BYParkEventModel.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYParkPopView ()

@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ParkAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;


@end

@implementation BYParkPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setParkModel:(BYParkEventModel *)parkModel
{
    self.parkNameLabel.text = @"事件名称：停车";
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",parkModel.beginTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",parkModel.endTime];
    self.ParkAddressLabel.text = parkModel.address;

    self.lastTimeLabel.text = [NSString stringWithFormat:@"持续时间：%@",parkModel.parkingTime];
   
    
    parkModel.pop_H = [self caculatePop_HWith:parkModel];
}


-(CGFloat)caculatePop_HWith:(BYParkEventModel *)model{
    CGFloat base_H = BYS_W_H(16) * 5 + 10 * 2 + 2 * 4;
    CGFloat address_H = [UILabel caculateLabel_HWith:BYS_W_H(150) Title:self.ParkAddressLabel.text font:13];
    return base_H + address_H;
}



@end
