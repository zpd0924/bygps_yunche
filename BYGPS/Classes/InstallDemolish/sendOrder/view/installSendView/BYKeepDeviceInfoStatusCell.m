//
//  BYKeepDeviceInfoStatusCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDeviceInfoStatusCell.h"

@interface BYKeepDeviceInfoStatusCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYKeepDeviceInfoStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
}
- (void)setModel:(BYKeepDeviceInfoStatusModel *)model{
    _model = model;
    self.titleLabel.text = model.resonStr;
    if (model.isSelect) {
        self.titleLabel.layer.borderColor = BYGlobalBlueColor.CGColor;
        self.titleLabel.layer.borderWidth = 0.5;
        self.titleLabel.layer.cornerRadius = 2;
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.textColor = BYGlobalBlueColor;
    }else{
        self.titleLabel.layer.borderColor = BYBigSpaceColor.CGColor;
        self.titleLabel.layer.borderWidth = 0.5;
        self.titleLabel.layer.cornerRadius = 2;
        self.titleLabel.layer.masksToBounds = YES;
         self.titleLabel.textColor = UIColorHexFromRGB(0x333333);
    }
}

@end
