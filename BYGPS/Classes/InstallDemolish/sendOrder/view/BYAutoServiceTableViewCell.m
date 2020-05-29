//
//  BYAutoServiceTableViewCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceTableViewCell.h"
#import "BYAutoServiceModel.h"

@interface BYAutoServiceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation BYAutoServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5.0;
    self.backView.layer.masksToBounds = YES;
}

-(void)setModel:(BYAutoServiceModel *)model{
    _model = model;
    
    self.headImg.image = model.image;
    self.titleLabel.text = model.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
