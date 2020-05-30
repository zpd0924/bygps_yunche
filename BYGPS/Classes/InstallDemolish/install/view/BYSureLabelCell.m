//
//  BYSureLabelCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSureLabelCell.h"
#import "BYInstallModel.h"

@interface BYSureLabelCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint_W;

@end

@implementation BYSureLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabelContraint_W.constant = BYS_W_H(120);
}

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
    self.subtitleLabel.text = model.subTitle;

}

-(NSAttributedString *)attributeStringWith:(NSString *)str{
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    return attrStr;
}

@end
