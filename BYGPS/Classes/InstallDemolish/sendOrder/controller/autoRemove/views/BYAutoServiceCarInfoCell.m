//
//  BYAutoServiceCarInfoCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceCarInfoCell.h"
#import "BYAutoServiceCarModel.h"

@interface BYAutoServiceCarInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *carTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carVinLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;


@end

@implementation BYAutoServiceCarInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCarModel:(BYAutoServiceCarModel *)carModel{
    _carModel = carModel;
    self.carTitleLabel.text = [NSString stringWithFormat:@"%@  |  %@",[carModel.carNum isKindOfClass:[NSNull class]] ? @"-" : carModel.carNum.length == 0 ? @"-" : carModel.carNum,([carModel.carOwner isKindOfClass:[NSNull class]] ? @"-" : carModel.carOwner.length == 0 ? @"-" : carModel.carOwner)];
    self.carModelLabel.text = [NSString stringWithFormat:@"%@%@%@",carModel.carBrand,carModel.carType.length > 0 ? carModel.carType : @"",carModel.carColor];
    self.carVinLabel.text = [NSString stringWithFormat:@"车架号：%@",carModel.carVin];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
