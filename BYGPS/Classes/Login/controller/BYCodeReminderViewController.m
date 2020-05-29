//
//  BYCodeReminderViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYCodeReminderViewController.h"
#import "BYCodeImageView.h"

@interface BYCodeReminderViewController ()

@property (nonatomic,strong) BYCodeImageView *codeImageView;
@property (nonatomic,strong) NSString *imageCode;//图形验证码
@property (nonatomic,strong) NSString *numberCode;//输入的验证码
@property (weak, nonatomic) IBOutlet UIView *imageCodeView;
@property (weak, nonatomic) IBOutlet UIView *refreshView;

@end

@implementation BYCodeReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageCodeView addSubview:self.codeImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshBtnClick)];
    [self.refreshView addGestureRecognizer:tap];
}
//刷新
- (IBAction)refreshBtnClick {
     [_codeImageView freshVerCode];
}

//取消
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//确定
- (IBAction)sureBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.numberCode.length) {
        BYShowError(@"请输入验证码");
        return;
    }
    if (![[self.numberCode lowercaseString] isEqualToString:self.imageCode]) {
        BYShowError(@"验证码错误");
        return;
    }
    if (self.codeReminderBlock) {
        self.codeReminderBlock(YES);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (IBAction)enterEditingDidEndClick:(UITextField *)sender {
    self.numberCode = sender.text;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [_codeImageView freshVerCode];
}


-(BYCodeImageView *)codeImageView
{
    if (!_codeImageView) {
        BYWeakSelf;
        _codeImageView = [[BYCodeImageView alloc] initWithFrame:CGRectMake(0, 7.5, 80.f, 35.f)];
        _codeImageView.bolck = ^(NSString *imageCodeStr){
            NSLog(@"imageCodeStr = %@",imageCodeStr);
           
            weakSelf.imageCode = [imageCodeStr lowercaseString];
        };
        _codeImageView.isRotation = NO;
        [_codeImageView freshVerCode];
        //点击刷新
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_codeImageView addGestureRecognizer:tap];
       
    }
    return _codeImageView;
}
@end
