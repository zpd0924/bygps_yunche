//
//  BYBreakOilCell.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBreakOilCell.h"

@interface BYBreakOilCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYBreakOilCell

-(void)setIsSelect:(BOOL)isSelect{
    self.selectButton.selected = isSelect;
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

@end
