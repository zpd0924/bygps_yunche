//
//  BYParkEventHeaderView.m
//  BYGPS
//
//  Created by ZPD on 2017/8/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYParkEventHeaderView.h"

@interface BYParkEventHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumNameLabel;

@end

@implementation BYParkEventHeaderView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}
-(void)setSn:(NSString *)sn
{
    self.snLabel.text = [NSString stringWithFormat:@"设备号：%@",sn];
}
-(void)setCarNumName:(NSString *)carNumName
{
    self.carNumNameLabel.text = carNumName;
}
@end
