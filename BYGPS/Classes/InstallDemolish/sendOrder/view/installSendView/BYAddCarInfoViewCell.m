//
//  BYAddCarInfoViewCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAddCarInfoViewCell.h"
#import "YBCustomCameraVC.h"
#import "BYRegularTool.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface BYAddCarInfoViewCell()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;


@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *selectOtherTitleArray;
@property (nonatomic,strong) NSArray *titleArray1;
@property (nonatomic,strong) NSArray *titleArray2;
@property (nonatomic,strong) NSArray *placeArray1;
@property (nonatomic,strong) NSArray *placeArray2;
@property (nonatomic,strong) NSArray *placeArray;
@property (nonatomic,strong) NSArray *infoArray;

@property (nonatomic,strong) UIViewController *cf_viewController;

@end


@implementation BYAddCarInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
//   [self.textField setValue:UIColorHexFromRGB(0x9d9d9d) forKeyPath:@"_placeholderLabel.textColor"];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setModel:(BYAddCarInfoModel *)model{
    _model = model;
    
    
}
- (IBAction)editDiiEndClick:(UITextField *)sender {
   
    
    if (_indexPath.row == 1 && _indexPath.section == 1) {
        if (![BYRegularTool validatePhone:sender.text]) {
            return BYShowError(@"请输入正确的手机号码");
        }
    }
    //车架号转大写
    if (_isAutoInstall) {
        if (_indexPath.section == 0 && _indexPath.row == 0) {

            _textField.text = [_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
       
            _textField.text = [sender.text uppercaseString];
          
            
        }
    }else{
        if (_indexPath.section == 0 && _indexPath.row == 1) {
             _textField.text = [_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            _textField.text = [sender.text uppercaseString];
            
        }
    }

    if (self.addCarInfoBlock) {
        self.addCarInfoBlock([_textField.text uppercaseString], _indexPath);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    if (_isAutoInstall) {
        if (_indexPath.section == 0 && _indexPath.row == 0) {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return [string isEqualToString:filtered];
        }else{
            return YES;
        }
    }else{
        if (_indexPath.section == 0 && _indexPath.row == 1) {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }else{
            return YES;
        }
    }
  
    
 
   
}

- (IBAction)changeTextField:(UITextField *)sender {
    if (_isAutoInstall) {
        if (_indexPath.section == 0 && _indexPath.row == 0) {
            if (sender.text.length > 17) {
                BYShowError(@"最多可输入17个字符");
                sender.text = [sender.text substringToIndex:17];
                return;
            }
        }
        
        if (_indexPath.row == 0 && _indexPath.section == 1) {
            if (sender.text.length > 30) {
                BYShowError(@"最多可输入30个字符");
                sender.text = [sender.text substringToIndex:30];
                return;
            }
        }
        if (_indexPath.row == 1 && _indexPath.section == 1) {
            if (sender.text.length > 11) {
                BYShowError(@"最多可输入11个字符");
                sender.text = [sender.text substringToIndex:11];
            }
        }
        if (_indexPath.row == 2 && _indexPath.section == 1) {
            if (sender.text.length > 50) {
                BYShowError(@"最多可输入50个字符");
                sender.text = [sender.text substringToIndex:50];
            }
        }
        if (_indexPath.row == 5 && _indexPath.section == 0) {

            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];// 键盘输入模式
            if([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [sender markedTextRange];
                //获取高亮部分
                UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if(!position) {
                    if(sender.text.length > 4) {
                        BYShowError(@"最多可输入4个字符");
                        sender.text = [sender.text substringToIndex:4];
                        
                    }
                    
                }
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                    
                }
                
            }

            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if(sender.text.length > 4) {
                    BYShowError(@"最多可输入4个字符");
                    sender.text = [sender.text substringToIndex:4];

                }

            }
            
//            if (sender.text.length > 4) {
//                BYShowError(@"最多可输入4个字符");
//                sender.text = [sender.text substringToIndex:4];
//            }
        }
    }else{
        if (_indexPath.section == 0 && _indexPath.row == 1) {
            if (sender.text.length > 17) {
                BYShowError(@"最多可输入17个字符");
                sender.text = [sender.text substringToIndex:17];
                return;
            }
        }
        
        if (_indexPath.row == 0) {
            if (sender.text.length > 30) {
                BYShowError(@"最多可输入30个字符");
                sender.text = [sender.text substringToIndex:30];
                return;
            }
        }
        if (_indexPath.row == 1 && _indexPath.section == 1) {
            if (sender.text.length > 11) {
                BYShowError(@"最多可输入11个字符");
                sender.text = [sender.text substringToIndex:11];
            }
        }
        if (_indexPath.row == 2 && _indexPath.section == 1) {
            if (sender.text.length > 50) {
                BYShowError(@"最多可输入50个字符");
                sender.text = [sender.text substringToIndex:50];
            }
        }
        if (_indexPath.row == 5 && _indexPath.section == 0) {
            NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];// 键盘输入模式
            if([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [sender markedTextRange];
                //获取高亮部分
                UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if(!position) {
                    if(sender.text.length > 4) {
                        BYShowError(@"最多可输入4个字符");
                        sender.text = [sender.text substringToIndex:4];
                        
                    }
                    
                }
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
                else{
                    
                }
                
            }
            
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            else{
                if(sender.text.length > 4) {
                    BYShowError(@"最多可输入4个字符");
                    sender.text = [sender.text substringToIndex:4];
                    
                }
                
            }
        }
    }
   
}
- (IBAction)didChangeOtherColorTextField:(UITextField *)sender {
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];// 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [sender markedTextRange];
        //获取高亮部分
        UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(sender.text.length > 4) {
                BYShowError(@"最多可输入4个字符");
                sender.text = [sender.text substringToIndex:4];
                
            }
            
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
        
    }
    
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if(sender.text.length > 4) {
            BYShowError(@"最多可输入4个字符");
            sender.text = [sender.text substringToIndex:4];
            
        }
        
    }
}


- (IBAction)scanBtnClick:(UIButton *)sender {
    /*
    BYWeakSelf;
    YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
    camera.index = 2;
    camera.vinBlock = ^(NSString *vin) {
        BYLog(@"vin = %@",vin);
        self.textField.text = [vin uppercaseString];
        if (self.addCarInfoBlock) {
            self.addCarInfoBlock([vin uppercaseString], _indexPath);
        }
       
    };
   
    [self.cf_viewController presentViewController:camera animated:YES completion:nil];
     */
   
    if (self.scanBtnClickBlock) {
        self.scanBtnClickBlock();
    }
}



- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (_isAutoInstall) {
        if (_isInputVin) {
            self.titleLabel.attributedText = [BYObjectTool setTextColor:self.selectOtherColor ? self.selectOtherTitleArray[indexPath.section][indexPath.row] : self.titleArray1[indexPath.section][indexPath.row] FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:BYOrangeColor];
            self.textField.placeholder = self.selectOtherColor ? self.placeArray2[indexPath.section][indexPath.row] :  self.placeArray1[indexPath.section][indexPath.row];
        }else{
            self.titleLabel.attributedText = [BYObjectTool setTextColor:self.selectOtherColor ? self.selectOtherTitleArray[indexPath.section][indexPath.row] : self.titleArray2[indexPath.section][indexPath.row] FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:BYOrangeColor];
            self.textField.placeholder = self.placeArray2[indexPath.section][indexPath.row];
            
        }
      
        
    }else{
        self.titleLabel.attributedText = [BYObjectTool setTextColor:self.selectOtherColor ? self.selectOtherTitleArray[indexPath.section][indexPath.row] : self.titleArray[indexPath.section][indexPath.row] FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:BYOrangeColor];
          self.textField.placeholder = self.placeArray[indexPath.section][indexPath.row];
    }
   
    self.infoLabel.text = self.infoArray[indexPath.section][indexPath.row];
  
    [self cellLayout];
}

-(void)setSelectOtherColor:(BOOL)selectOtherColor{
    _selectOtherColor = selectOtherColor;
}
- (void)cellLayout{
    if (_indexPath.section == 0) {
        switch (_indexPath.row) {
            case 0:
            case 1:
            {
                self.infoLabel.hidden = YES;
                self.textField.hidden = NO;
                self.textField.enabled = YES;
                self.scanBtn.hidden = NO;
                self.moreImageView.hidden = YES;
               
                if (_isAutoInstall) {
                    if (_isInputVin) {
                        self.textField.enabled = YES;
                         self.textField.text = [_model.carVin uppercaseString];
                    }else{
                        self.textField.enabled = NO;
                        self.scanBtn.hidden = YES;
                    }
                }else{
                    self.textField.text = [_model.carVin uppercaseString];
                }
               
            }
                break;
            case 2:
            {
                self.infoLabel.hidden = YES;
                self.textField.enabled = NO;
                self.textField.hidden = NO;
                self.scanBtn.hidden = YES;
                self.moreImageView.hidden = NO;
                self.textField.text = _model.company;
                if (_isAutoInstall) {
                    self.moreImageView.hidden = YES;
                }
                
            }
                break;
            case 3:
            {
                self.infoLabel.hidden = YES;
                self.textField.hidden = NO;
                self.textField.enabled = NO;
                self.scanBtn.hidden = YES;
                self.moreImageView.hidden = NO;
                self.textField.text = [NSString stringWithFormat:@"%@%@%@",_model.brand.length?_model.brand:@"",_model.carType.length?_model.carType:@"",_model.carModel.length?_model.carModel:@""];
            }
                break;
            case 4:
            {
                self.infoLabel.hidden = YES;
                self.textField.hidden = NO;
                self.textField.enabled = NO;
                self.scanBtn.hidden = YES;
                self.moreImageView.hidden = NO;
                self.textField.text = _model.color;
            }
                break;
            case 5:
            {
                self.infoLabel.hidden = YES;
                self.textField.hidden = NO;
                self.textField.enabled = YES;
                self.scanBtn.hidden = YES;
                self.moreImageView.hidden = YES;
                self.textField.text = _model.otherColor;
            }
                break;
            default:
            {
                self.infoLabel.hidden = YES;
                self.textField.hidden = NO;
                self.textField.enabled = NO;
                self.scanBtn.hidden = YES;
                self.moreImageView.hidden = NO;
                self.textField.text = _model.color;
            }
                break;
        }
    }else{
        
        self.infoLabel.hidden = YES;
        self.textField.hidden = NO;
        self.scanBtn.hidden = YES;
        self.moreImageView.hidden = YES;
        switch (_indexPath.row) {
            case 0:
            {
                self.textField.keyboardType = UIKeyboardTypeDefault;
                if (_isAutoInstall) {//有姓名显示姓名 没有姓名显示占位文字
                    if (_model.ownerName.length) {
                         self.textField.text = @"";
                    }else{
                        self.textField.text = @"";
                    }
                   
                }else{
                    self.textField.text = _model.ownerName;
                }
                
            }
                break;
                
            case 1:
            {
                if (_isAutoInstall) {
                    if (_model.ownerTel.length) {
                        self.textField.text = @"";
                    }else{
                        self.textField.text = @"";
                    }
                }else{
                    self.textField.text = _model.ownerTel;
                }
                
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
                
            }
                break;
                
            default:
            {
                if (_isAutoInstall) {
                    if (_model.contractNo.length) {
                         self.textField.text = @"";
                    }else{
                        self.textField.text = @"";
                    }
                }else{
                    self.textField.text = _model.contractNo;
                }
                
                self.textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
        }
    }
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@[@"车牌号",@"*车架号",@"*所属公司",@"车辆品牌",@"*车辆颜色"],@[@"车主姓名",@"车主电话",@"合同编号"]];
    }
    return _titleArray;
}
-(NSArray *)selectOtherTitleArray
{
    if (!_selectOtherTitleArray) {
        _selectOtherTitleArray = @[@[@"车牌号",@"*车架号",@"*所属公司",@"车辆品牌",@"*车辆颜色",@""],@[@"车主姓名",@"车主电话",@"合同编号"]];
    }
    return _selectOtherTitleArray;
}
-(NSArray *)titleArray1
{
    if (!_titleArray1) {
        _titleArray1 = @[@[@"*车架号",@"车牌号",@"*所属公司",@"车辆品牌",@"*车辆颜色"],@[@"车主姓名",@"车主电话",@"合同编号"]];
    }
    return _titleArray1;
}
-(NSArray *)titleArray2
{
    if (!_titleArray2) {
        _titleArray2 = @[@[@"车架号",@"*车牌号",@"*所属公司",@"车辆品牌",@"*车辆颜色"],@[@"车主姓名",@"车主电话",@"合同编号"]];
    }
    return _titleArray2;
}
-(NSArray *)placeArray1
{
    if (!_placeArray1) {
        _placeArray1 = @[@[@"请输入17位车架号(数字+字母)",@"请输入5-6位数字+字母",@"",@"请选择车辆品牌和型号",@"请选择车辆颜色"],@[@"请输入车主姓名",@"请选择车主电话",@"请输入合同编号"]];
    }
    return _placeArray1;
}
-(NSArray *)placeArray2
{
    if (!_placeArray2) {
        _placeArray2 = @[@[@"无需填写车架号",@"请输入5-6位数字+字母",@"",@"请选择车辆品牌和型号",@"请选择车辆颜色",@"请输入车辆颜色名称"],@[@"请输入车主姓名",@"请选择车主电话",@"请输入合同编号"]];
    }
    return _placeArray2;
}
-(NSArray *)placeArray
{
    if (!_placeArray) {
        _placeArray = @[@[@"请输入5-6位数字+字母",@"请输入17位车架号(数字+字母)",@"请选择",@"请选择车辆品牌和型号",@"请选择车辆颜色",@"请输入车辆颜色名称"],@[@"请输入车主姓名",@"请选择车主电话",@"请输入合同编号"]];
    }
    return _placeArray;
}
-(NSArray *)infoArray
{
    if (!_infoArray) {
        _infoArray = @[@[@"",@"",@"请选择",@"",@"请选择车辆颜色",@"请输入车辆颜色名称"],@[@"",@"",@""]];
    }
    return _infoArray;
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
