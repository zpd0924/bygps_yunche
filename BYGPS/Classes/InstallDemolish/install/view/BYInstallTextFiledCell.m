//
//  BYInstallTextFiledCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallTextFiledCell.h"
#import "BYInstallModel.h"

@interface BYInstallTextFiledCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint_W;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end

@implementation BYInstallTextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.textField.delegate = self;
}

-(void)setIsHiddenTopLine:(BOOL)isHiddenTopLine{
    self.topLine.hidden = isHiddenTopLine;
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
    
    self.textField.placeholder = model.placeholder;
    
    self.textField.text = model.subTitle;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.shouldEndInputBlock) {
        self.shouldEndInputBlock(textField.text);
    }
    return YES;
}

-(NSAttributedString *)attributeStringWith:(NSString *)str{
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    return attrStr;
}

@end





