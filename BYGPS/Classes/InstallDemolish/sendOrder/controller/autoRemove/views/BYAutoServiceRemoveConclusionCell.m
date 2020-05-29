//
//  BYAutoServiceRemoveConclusionCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceRemoveConclusionCell.h"
#import "BYRemoveConclusionModel.h"


static NSString * const placeholderStr = @"请输入拆机备注...";

@interface BYAutoServiceRemoveConclusionCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *strNumLabel;

@end

@implementation BYAutoServiceRemoveConclusionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.remarkTextView.layer.cornerRadius = 5;
    self.remarkTextView.clipsToBounds = YES;
    self.remarkTextView.layer.borderWidth = 1;
    self.remarkTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.remarkTextView.text = placeholderStr;
    self.remarkTextView.font = BYS_T_F(13);
    self.remarkTextView.textColor = UIColorHexFromRGB(0x9b9b9b);
    self.remarkTextView.delegate = self;
    
    // Initialization code
}

-(void)setConclusionModel:(BYRemoveConclusionModel *)conclusionModel{
    _conclusionModel = conclusionModel;
    
    self.remarkTextView.text = conclusionModel.remarkStr.length > 0 ? conclusionModel.remarkStr : placeholderStr;
    
    switch (conclusionModel.uninstallReson) {
        case 1:
            [self.removeReasonButton setTitle:@"清货拆机" forState:UIControlStateNormal];
            break;
        case 2:
            [self.removeReasonButton setTitle:@"关联错误" forState:UIControlStateNormal];
            break;
        case 3:
            [self.removeReasonButton setTitle:@"悔贷拆机" forState:UIControlStateNormal];
            break;
            
        default:
            [self.removeReasonButton setTitle:@"请选择" forState:UIControlStateNormal];
            break;
    }
    
//    [self.removeReasonButton setTitle:conclusionModel.uninstallReson == 1 ? @"清贷拆机" : (conclusionModel.uninstallReson == 2 ? @"关联错误" : @"悔贷拆机") forState:UIControlStateNormal];
}

- (IBAction)removeReasonClick:(id)sender {
    if (self.removeReasonBlock) {
        self.removeReasonBlock();
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:placeholderStr]) {
        
        textView.text = @"";
        self.remarkTextView.textColor = UIColorHexFromRGB(0x3a3a3a);
        
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (textView.text.length > 200) {
//        BYShowError(@"最多输入200个字符");
//        return NO;
//    }
//    return YES;
//}

- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:placeholderStr]) {
        
        self.strNumLabel.text = @"0/200";
        
    }else{
        self.strNumLabel.text = [NSString stringWithFormat:@"%zd/200",textView.text.length];
    }

    if (textView.text.length > 200) {
        BYShowError(@"最多输入200个字符");
        UITextRange *markedRange = [textView markedTextRange];
        if (markedRange) {
            return;
          }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:200];
        textView.text = [textView.text substringToIndex:range.location];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length<1) {
        
        textView.text = placeholderStr;
        self.remarkTextView.textColor = UIColorHexFromRGB(0x9b9b9b);
        self.conclusionModel.remarkStr = @"";
    }else{
        self.conclusionModel.remarkStr = textView.text;
    }  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.remarkTextView resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
