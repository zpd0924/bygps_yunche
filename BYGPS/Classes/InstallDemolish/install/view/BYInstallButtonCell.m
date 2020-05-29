//
//  BYInstallButtonCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallButtonCell.h"
#import "BYInstallModel.h"

@interface BYInstallButtonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint_W;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@end

@implementation BYInstallButtonCell

-(void)setTitleLabel_W:(CGFloat)titleLabel_W{
    self.titleLabelContraint_W.constant = titleLabel_W;
}

-(void)setModel:(BYInstallModel *)model{
    if (model.isNecessary) {
        self.titleLabel.attributedText = [self attributeStringWith:model.title];
    }else{
        self.titleLabel.text = model.title;
    }

    //是否subtitle有值,有就显示subtitle,没有就显示placeholder
    self.subtitleLabel.text = model.subTitle ? model.subTitle : model.placeholder;
    self.subtitleLabel.textColor = model.subTitle ? [UIColor blackColor] : BYGrayColor(178);
}

-(NSAttributedString *)attributeStringWith:(NSString *)str{
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    return attrStr;
}
@end
