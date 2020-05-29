//
//  BYProvinceCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYProvinceCell.h"

@interface BYProvinceCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYProvinceCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setProvince:(NSString *)province{
    self.titleLabel.text = province;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.titleLabel.backgroundColor = selected ? [UIColor whiteColor] : BYGrayColor(234);
    self.titleLabel.textColor = selected ? [UIColor redColor] : [UIColor blackColor];
}

@end
