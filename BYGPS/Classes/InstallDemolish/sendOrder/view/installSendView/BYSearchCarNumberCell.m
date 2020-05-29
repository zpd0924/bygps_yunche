//
//  BYSearchCarNumberCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/14.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSearchCarNumberCell.h"


@interface BYSearchCarNumberCell()

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

@end

@implementation BYSearchCarNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(BYSearchCarByNumOrVinModel *)model{
    _model = model;
    if (model.carNum.length) {
        self.carNumberLabel.text = model.carNum;
    }else{
        self.carNumberLabel.text = model.carVin;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
