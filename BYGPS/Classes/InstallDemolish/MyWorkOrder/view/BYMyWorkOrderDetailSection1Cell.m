//
//  BYMyWorkOrderDetailSection1Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailSection1Cell.h"

@interface BYMyWorkOrderDetailSection1Cell()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stausImageView;

@end


@implementation BYMyWorkOrderDetailSection1Cell


- (void)setModel:(BYMyWorkOrderDetailSection1Model *)model{
    _model = model;
    self.topView.hidden = model.isHiddenTopView;
    self.bottomView.hidden = model.isHiddenBottomView;
    self.titleLabel.text = model.titleStr;
    self.dateLabel.text = model.dateStr;
    self.stausImageView.image = [UIImage imageNamed:model.imageStr];
    
}


@end
