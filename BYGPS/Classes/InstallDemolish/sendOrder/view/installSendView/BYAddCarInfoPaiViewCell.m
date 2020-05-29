//
//  BYAddCarInfoPaiViewCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAddCarInfoPaiViewCell.h"
#import "BYButton.h"
#import "YBCustomCameraVC.h"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface BYAddCarInfoPaiViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *carNumberBtn;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (nonatomic,weak) UIViewController *cf_viewController;

@end

@implementation BYAddCarInfoPaiViewCell

- (IBAction)carNumberBtnClick:(id)sender {
    if (self.carInfoPaiBlock) {
        self.carInfoPaiBlock();
    }
}
- (void)setModel:(BYAddCarInfoModel *)model{
    _model = model;


  NSString *carFirstNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"];
    if (carFirstNum.length) {
         [self.carNumberBtn setTitle:carFirstNum forState:UIControlStateNormal];
    }else{
         [self.carNumberBtn setTitle:@"粤B" forState:UIControlStateNormal];
    }
   
    if (model.carFirstNum.length) {
        [self.carNumberBtn setTitle:model.carFirstNum forState:UIControlStateNormal];
    }
    self.textField.text = model.carLastNum;
    self.scanBtn.hidden = !_isAutoInstall;
    if (_isAutoInstall) {
        if (_isInputVin) {
            self.titleLabel.text = @"车牌号";
        }else{
           self.titleLabel.attributedText = [BYObjectTool setTextColor:@"*车牌号" FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:BYOrangeColor];
        }
    }else{
         self.titleLabel.text = @"车牌号";
    }
    
}

- (IBAction)scanBtnClick:(UIButton *)sender {
    BYWeakSelf;
    /*
    YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
    camera.index = 1;
    camera.carNumberBlock = ^(NSString *num) {
        BYLog(@"carNum = %@",num);
//        self.textField.text = num;
        if (weakSelf.carNumBlock) {
            weakSelf.carNumBlock(num);
        }
    };
   
    
    
    [self.cf_viewController presentViewController:camera animated:YES completion:nil];
     */
   
    if (self.scanBtnClickBlock) {
        self.scanBtnClickBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.textField.delegate = self;
//    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName: UIColorHexFromRGB(0x9d9d9d)}];
//     [self.textField setValue:UIColorHexFromRGB(0x9d9d9d) forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}
- (IBAction)changeTextField:(UITextField *)sender {
    if (sender.text.length > 6) {
        BYShowError(@"最多不能超过6个字符");
        sender.text = [sender.text substringToIndex:6];
    }
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text uppercaseString];
    
    NSString *urlStr = nil;
    urlStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    BYLog(@"urlStr = %@",urlStr);
    
    if (self.carNumBlock) {
        self.carNumBlock(urlStr);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    return YES;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIViewController*)cf_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController * )nextResponder;
        }
    }
    return nil;
}

@end
