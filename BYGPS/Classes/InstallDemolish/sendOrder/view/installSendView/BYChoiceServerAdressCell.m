//
//  BYChoiceServerAdressCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressCell.h"

@interface BYChoiceServerAdressCell()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end


@implementation BYChoiceServerAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel1:(BYChoiceServerAdressModel *)model1{
    _model1 = model1;
    self.codeLabel.text = model1.firstCode;
    self.titleLabel.text = model1.pName;
    self.codeLabel.hidden = model1.isHidden;
  
}
- (void)setModel2:(BYChoiceServerAdressCityModel *)model2{
    _model2 = model2;
    self.codeLabel.text = model2.firstCode;
    self.titleLabel.text = model2.cityName;
     self.codeLabel.hidden = model2.isHidden;
    
}
- (void)setModel3:(BYChoiceServerAdressAreaModel *)model3{
    _model3 = model3;
    self.codeLabel.text = model3.firstCode;
    self.titleLabel.text = model3.areaName;
     self.codeLabel.hidden = model3.isHidden;
   
}
@end
