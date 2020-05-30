//
//  BYCarTypeViewBrandCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeViewBrandCell.h"
#import "UIImageView+WebCache.h"
@interface BYCarTypeViewBrandCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYCarTypeViewBrandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(BYCarTypeBrandModel *)model{
    _model = model;
    self.titleLabel.text = model.brand_name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ssl-assets.che300.com/theme/images/brand/large/b%@.jpg",model.brand_id]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
