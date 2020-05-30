//
//  BYParkEventSectionView.m
//  BYGPS
//
//  Created by ZPD on 2017/8/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYParkEventSectionView.h"

@interface BYParkEventSectionView ()
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation BYParkEventSectionView

-(void)setBeginTime:(NSString *)beginTime
{
    self.beginTimeLabel.text = [NSString stringWithFormat:@"起始时间：%@",beginTime];
    
}

-(void)setEndTime:(NSString *)endTime
{
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",endTime];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
