//
//  BYOTSWeakCell.m
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSWeakCell.h"

@interface BYOTSWeakCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@end

@implementation BYOTSWeakCell

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setIsSelect:(BOOL)isSelect
{
    self.arrowImgView.hidden = !isSelect;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separateView.backgroundColor = BYGlobalBg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
