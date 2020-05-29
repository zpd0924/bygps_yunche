//
//  BYShareDeviceTypeCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareDeviceTypeCell.h"

@interface BYShareDeviceTypeCell()

@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;


@end

@implementation BYShareDeviceTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.deviceTitleLabel.text = [NSString stringWithFormat:@"设备:%zd",indexPath.row + 1];
}
- (void)setModel:(BYShareCommitDeviceModel *)model{
    _model = model;
    self.deviceLabel.text = [NSString stringWithFormat:@"%@(%@%@)",model.deviceSn.length?model.deviceSn:@"",model.deviceModel.length?model.deviceModel:@"",model.wifi == 0?@"有线":@"无线"];
    
    
}
- (void)setIsDated:(BOOL)isDated{
    _isDated = isDated;
    if (isDated) {
        self.deviceLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
        self.detailTextLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
        self.controlLabel.textColor = UIColorHexFromRGB(0xA9A9A9);
        self.moreImageView.hidden = YES;
        self.controlLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
