//
//  BYMyWorkOrderScreenStatusColloctionCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderScreenStatusColloctionCell.h"

@interface BYMyWorkOrderScreenStatusColloctionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYMyWorkOrderScreenStatusColloctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYMyWorkOrderScreenStatusModel *)model{
    _model = model;
     _titleLabel.text = model.screenName;
    if (model.isSelect) {
        _titleLabel.backgroundColor = BYGlobalBlueColor;
        _titleLabel.textColor = WHITE;
    }else{
        _titleLabel.backgroundColor = UIColorFromToRGB(241, 241, 241);
        _titleLabel.textColor = BYLabelBlackColor;
    }
}
@end
