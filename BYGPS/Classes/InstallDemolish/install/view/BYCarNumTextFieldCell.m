//
//  BYCarNumTextFieldCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYCarNumTextFieldCell.h"
#import "BYInstallModel.h"

@interface BYCarNumTextFieldCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *carButton;
@property (weak, nonatomic) IBOutlet UIView *carNumButtonBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carNumButtonBgViewContraint_W;


@end

@implementation BYCarNumTextFieldCell

-(void)setCarNum:(NSString *)carNum{
    
    self.carNumButtonBgViewContraint_W.constant = carNum.length ? 60 : 0;
    self.carNumButtonBgView.hidden = !carNum.length;
    if (carNum.length) {
        [self.carButton setTitle:carNum forState:UIControlStateNormal];
    }
}

- (IBAction)carNumSelect:(UIButton *)sender {
    if (self.carNumSelectBlock) {
        self.carNumSelectBlock(sender.titleLabel.text);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.carButton.layer.borderWidth = 1;
    self.carButton.layer.borderColor = [UIColor colorWithHex:@"#f9d8af"].CGColor;
    self.carButton.layer.cornerRadius = 2;
    self.carButton.clipsToBounds = YES;
    
    self.textField.delegate = self;
}

-(void)setModel:(BYInstallModel *)model{
    if (model.isNecessary) {
        self.titleLabel.attributedText = [self attributeStringWith:model.title];
    }else{
        self.titleLabel.text = model.title;
    }
    
    self.textField.placeholder = model.placeholder;
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
