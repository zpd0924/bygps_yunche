//
//  BYCarTypeViewModelCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeViewModelCell.h"


@interface BYCarTypeViewModelCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYCarTypeViewModelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel1:(BYCarTypeSetModel *)model1{
    _model1 = model1;
    self.titleLabel.text = model1.series_name;
}
- (void)setModel2:(BYCarTypeInfoModel *)model2{
    _model2 = model2;
    self.titleLabel.text = model2.model_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
