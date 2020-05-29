//
//  BYMyWorkOrderDetailSection3Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailSection3Cell.h"

@interface BYMyWorkOrderDetailSection3Cell()

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *vinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;


@end

@implementation BYMyWorkOrderDetailSection3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYOrderDetailModel *)model{
    _model = model;
    self.carNumberLabel.text = model.carNum;
    self.carUserLabel.text = model.carOwnerName;
    self.vinNumberLabel.text = model.carVin;
    self.carModelLabel.text = [NSString stringWithFormat:@"%@%@%@",model.carBrand.length ? model.carBrand : @"-",model.carType.length?model.carType:@"",model.carModel.length?model.carModel:@""];
}

@end
