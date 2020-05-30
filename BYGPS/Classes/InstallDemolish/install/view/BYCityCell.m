//
//  BYCityCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYCityCell.h"

@interface BYCityCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.titleLabel.textColor = selected ? [UIColor redColor] : [UIColor darkTextColor];
}

@end
