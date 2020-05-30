//
//  BYChoiceServerAdressHeadView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressHeadView.h"

@interface BYChoiceServerAdressHeadView()




@end


@implementation BYChoiceServerAdressHeadView
- (IBAction)provinceBtnClick:(UIButton *)sender {
    if (self.provinceBlock) {
        self.provinceBlock();
    }
    sender.selected = YES;
    self.cityBtn.selected = NO;
    self.areaBtn.selected = NO;
    sender.hidden = NO;
    self.provinceLine.hidden = NO;
    self.cityLine.hidden = YES;
    self.areaLine.hidden = YES;
}
- (IBAction)cityBtnClick:(UIButton *)sender {
    if (self.cityBlock) {
        self.cityBlock();
    }
    sender.selected = YES;
    self.provinceBtn.selected = NO;
    self.areaBtn.selected = NO;
    sender.hidden = NO;
    self.provinceLine.hidden = YES;
    self.cityLine.hidden = NO;
    self.areaLine.hidden = YES;
}
- (IBAction)areaBtnClick:(UIButton *)sender {
    if (self.areaBlock) {
        self.areaBlock();
    }
    sender.selected = YES;
    self.provinceBtn.selected = NO;
    self.cityBtn.selected = NO;
    sender.hidden = NO;
    self.provinceLine.hidden = YES;
    self.cityLine.hidden = YES;
    self.areaLine.hidden = NO;
}

- (void)setModel:(BYChoiceServerAdressModel *)model{
    _model = model;
    if (model.pName.length) {
        [self.provinceBtn setTitle:model.pName forState:UIControlStateNormal];
    }
    
    
    
}

- (void)setModel1:(BYChoiceServerAdressCityModel *)model1{
    _model1 = model1;
    if (model1.cityName.length) {
        [self.cityBtn setTitle:model1.cityName forState:UIControlStateNormal];
    }
}
- (void)setModel2:(BYChoiceServerAdressAreaModel *)model2{
    _model2 = model2;
    if (model2.areaName.length) {
        [self.areaBtn setTitle:model2.areaName forState:UIControlStateNormal];
    }
    
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if (_index == 1) {
        self.provinceBtn.selected = NO;
        self.cityBtn.selected = YES;
        self.areaBtn.selected = NO;
        self.provinceBtn.hidden = NO;
        self.cityBtn.hidden = NO;
        self.provinceLine.hidden = YES;
        self.cityLine.hidden = NO;
        self.areaLine.hidden = YES;
        
        self.areaBtn.hidden = YES;
        [self.cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        
    }else{
        self.provinceBtn.selected = NO;
        self.cityBtn.selected = NO;
        self.areaBtn.selected = YES;
        
        self.areaBtn.hidden = NO;
        self.provinceBtn.hidden = NO;
        self.cityBtn.hidden = NO;
        self.provinceLine.hidden = YES;
        self.cityLine.hidden = YES;
        self.areaLine.hidden = NO;
    }
}


@end
