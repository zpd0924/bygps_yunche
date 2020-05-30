//
//  BYRegisterViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYRegisterViewController.h"
#import "EasyNavigation.h"
#import "BYCodeReminderViewController.h"
#import "BYSendShareController.h"
#import "BYVerifyCodeButton.h"
#import "BYRegularTool.h"

@interface BYRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHCons;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (nonatomic,strong) BYVerifyCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

///手机号
@property (nonatomic,strong) NSString *phone;
///验证码
@property (nonatomic,strong) NSString *code;
///密码
@property (nonatomic,strong) NSString *password;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation BYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topHCons.constant = SafeAreaTopHeight + 10;
    [self.navigationView setTitle:_registerType==1?@"注册":@"忘记密码"];
    [self.codeView addSubview:self.codeButton];
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.sureBtn.enabled = NO;
    [self.sureBtn setBackgroundColor:BYBtnGrayColor];
    
}
- (IBAction)openOrCloseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text = tempPwdStr;
    }
    
 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.phoneTextField == textField) {
        return range.location < 11;
    }else if (self.codeTextField == textField){
        return range.location < 6;
    }else{
        if (range.location > 0) {
            self.openOrCloseBtn.hidden = NO;
        }else{
            self.openOrCloseBtn.hidden = YES;
        }
        if (range.location < 16) {
            return YES;
        }else{
            return NO;
        }
        return YES;
    }
   
}




#pragma mark -- 发送验证码
- (void)receiveCode{
    [self.view endEditing:YES];
    [self getsendCodeNumber];
}
#pragma mark -- 发送验证码接口
- (void)receiveCodeData{
    if (!self.phone.length) {
        BYShowError(@"请输入手机号");
        return;
    }
    if (![BYRegularTool isValidPhone:_phone]) {
        BYShowError(@"手机号格式不正确");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phone;
    dict[@"isReset"] = _registerType == BYRegisType?@"false":@"true";
    BYWeakSelf;
    [BYRequestHttpTool POSTSendCodeParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
        NSString *code = data[@"code"];
        switch ([code integerValue]) {
            case 10000000://成功
            {
                [weakSelf.codeButton timeFailBegin];
            }break;
            case 10000002://手机号码格式错误
            {
                BYShowError(@"手机号格式不正确");
                return;
            }break;
            case 10000018://该手机号已经绑定其他账号(已经注册)
            {
                BYShowError(@"手机号已注册");
                return;
            }break;
            case 10000019://短信验证码发送失效
            {
                BYShowError(@"短信验证码发送失效");
                return;
            }break;
            case 10000021://该手机不存在(用于重置密码)
            {
                if (_registerType == BYforgetPasswordType) {
                    BYShowError(@"手机号未注册");
                    return;
                }
                
            }break;
            case 10000022://手机验证码已发送3次
            {
                [weakSelf showImageCode];
            }break;
            case 10000023://手机验证码已发送10次
            {
                BYShowError(@"手机号今日已达到接收上限10次");
                return;
            }break;
            default:
                break;
        }
             });
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 获取当日验证码发送次数
- (void)getsendCodeNumber{
    if (!self.phone.length) {
        BYShowError(@"请输入手机号");
        return;
    }
    if (![BYRegularTool isValidPhone:_phone]) {
        BYShowError(@"手机号格式不正确");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phone;
    BYWeakSelf;
    [BYRequestHttpTool POSTSendCodeNumberParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYLog(@"%@",data);
            NSString *number = data;
            if ([number integerValue] >= 0 && [number integerValue] < 3) {//当日小于3次
                [weakSelf receiveCodeData];
            }else if([number integerValue] >= 3 && [number integerValue] <= 10){//当日>=3次
                [weakSelf showImageCode];
            }else{//当日>10次
                BYShowError(@"手机号今日已达到接收上限10次");
                return;
            }
        });
       
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)editingChangedClick:(UITextField *)sender {
    if (sender.text.length) {
        self.codeButton.enabled = YES;
        [self.codeButton setBackgroundColor:WHITE];
    }else{
        self.codeButton.enabled = NO;
        [self.codeButton setBackgroundColor:BYBtnGrayColor];
    }
}

//手机号
- (IBAction)enterPhoneEditingDidEndClick:(UITextField *)sender {
    self.phone = sender.text;
    if (sender.text.length) {
        self.codeButton.enabled = YES;
        [self.codeButton setBackgroundColor:WHITE];
    }else{
        self.codeButton.enabled = NO;
        [self.codeButton setBackgroundColor:BYBtnGrayColor];
    }
    if (self.phoneTextField.text.length && self.codeTextField.text.length && self.passwordTextField.text.length) {
        [self.sureBtn setBackgroundColor:BYGlobalBlueColor];
        self.sureBtn.enabled = YES;
    }else{
        [self.sureBtn setBackgroundColor:BYBtnGrayColor];
        self.sureBtn.enabled = NO;
    }
}
//验证码
- (IBAction)enterCodeEditingDidEndClick:(UITextField *)sender {
    self.code = sender.text;
    if (self.phoneTextField.text.length && self.codeTextField.text.length && self.passwordTextField.text.length) {
        [self.sureBtn setBackgroundColor:BYGlobalBlueColor];
        self.sureBtn.enabled = YES;
    }else{
        [self.sureBtn setBackgroundColor:BYBtnGrayColor];
        self.sureBtn.enabled = NO;
    }
}
//密码
- (IBAction)enterPasswordEditingDidEndClick:(UITextField *)sender {
    self.password = sender.text;
    if (self.phoneTextField.text.length && self.codeTextField.text.length && self.passwordTextField.text.length) {
        [self.sureBtn setBackgroundColor:BYGlobalBlueColor];
        self.sureBtn.enabled = YES;
    }else{
        [self.sureBtn setBackgroundColor:BYBtnGrayColor];
        self.sureBtn.enabled = NO;
    }
}

#pragma mark -- 图形验证码
- (void)showImageCode{
    BYWeakSelf;
    BYCodeReminderViewController *vc = [[BYCodeReminderViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.codeReminderBlock = ^(BOOL isCorrect) {
        if (isCorrect) {//图形验证码验证正确
            [weakSelf receiveCodeData];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- 确定
- (IBAction)sureBtnClick:(UIButton *)sender {
    
    _registerType == BYRegisType ?[self registerData]:[self forgetPassword];
    
}
#pragma mark -- 注册
- (void)registerData{
    if (!self.phone.length) {
        BYShowError(@"请输入手机号");
        return;
    }
    if (![BYRegularTool isValidPhone:_phone]) {
        BYShowError(@"手机号格式不正确");
        return;
    }
    if (!self.code.length) {
        BYShowError(@"验证码不能为空");
        return;
    }
    if ( self.password.length < 6 || self.password.length >18 ) {
        BYShowError(@"密码必须为6-18位");
        return;
    }
//    if ([BYRegularTool deptNumInputShouldNumber:self.password]) {
//        BYShowError(@"密码不能为纯数字");
//        return;
//    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phone;
    dict[@"password"] = self.password;
    dict[@"code"] = self.code;
    dict[@"type"] = @(1);
    BYWeakSelf;
    [BYRequestHttpTool POSTRegisterUsersParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShowSuccess(@"注册成功");
            if (weakSelf.registerBlock) {
                weakSelf.registerBlock(weakSelf.phone, weakSelf.password);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 忘记密码
- (void)forgetPassword{
    if (!self.phone.length) {
        BYShowError(@"请输入手机号");
        return;
    }
    if (![BYRegularTool isValidPhone:_phone]) {
        BYShowError(@"手机号格式不正确");
        return;
    }
    if (!self.code.length) {
        BYShowError(@"验证码不能为空");
        return;
    }
    if ( self.password.length < 6 || self.password.length >18 ) {
        BYShowError(@"密码必须为6-18位");
        return;
    }
//    if ([BYRegularTool deptNumInputShouldNumber:self.password]) {
//        BYShowError(@"密码不能为纯数字");
//        return;
//    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.phone;
    dict[@"password"] = self.password;
    dict[@"code"] = self.code;
    BYWeakSelf;
    [BYRequestHttpTool POSTResetPwdParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShowSuccess(@"修改密码成功");
            [BYSaveTool removeObjectForKey:BYpassword];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(BYVerifyCodeButton *)codeButton{
    if (_codeButton == nil) {
        _codeButton = [BYVerifyCodeButton buttonWithType:UIButtonTypeCustom];
        _codeButton.by_width = BYS_W_H(85);
        _codeButton.by_height = 30.f;
        _codeButton.by_centerY = 30.f / 2.0;
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = BYS_T_F(13);
        [_codeButton setTitleColor:BYGrayColor(70) forState:UIControlStateNormal];
        _codeButton.layer.cornerRadius = 5;
        _codeButton.clipsToBounds = YES;
        
        _codeButton.layer.borderColor = BYGrayColor(228).CGColor;
        _codeButton.layer.borderWidth = 1;
        
        [_codeButton addTarget:self action:@selector(receiveCode) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.enabled = NO;
        [_codeButton setBackgroundColor:BYBtnGrayColor];
        
    }
    return _codeButton;
}


@end
