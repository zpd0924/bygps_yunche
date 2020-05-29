//
//  BYReplayStartPopView.m
//  BYGPS
//
//  Created by ZPD on 2017/8/22.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYReplayStartPopView.h"
#import "BYReplayModel.h"
//#import "NSString+BYAttributeString.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYReplayStartPopView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation BYReplayStartPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setStartModel:(BYReplayModel *)startModel
{
    self.timeLabel.text = startModel.updateTime;

    startModel.pop_H = [self caculatePop_HWith:self.startModel];
}

-(void)setAddress:(NSString *)address
{
    self.addressLabel.text = address;
    self.startModel.pop_H = [self caculatePop_HWith:self.startModel];

}

-(CGFloat)caculatePop_HWith:(BYReplayModel *)model{
    //先计算基础高度
    //上下间距 + 行间距 + 底部按钮 + 车牌label + 4 * 无线有线都有的label
    CGFloat base_H = 10 * 2 + BYS_W_H(16) * 3 + 5 * 2;//144

    CGFloat addressLabel_H = [UILabel caculateLabel_HWith:BYS_W_H(160) Title:self.addressLabel.text font:13];
    
    CGFloat pop_H = base_H  + addressLabel_H;
    
    return pop_H;
}


-(void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

@end
