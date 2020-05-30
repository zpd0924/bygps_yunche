//
//  BYHandInputViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYHandInputViewController.h"
#import "EasyNavigation.h"
#import "BYInstallRecordViewController.h"
#import "BYInstallDeviceCheckModel.h"
#import "BYInstallDeviceCheckViewController.h"
@interface BYHandInputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong) BYInstallDeviceCheckModel *model;

@end

@implementation BYHandInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
    [self initBase];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)installRecord{
    BYInstallRecordViewController *vc = [[BYInstallRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)initBase{
    [self.navigationView setTitle:@"手动输入"];
    BYWeakSelf;
    self.view.backgroundColor = BYBackViewColor;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
        [self.navigationView removeAllRightButton];
//
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//
//
//    });
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.masksToBounds = YES;
}
- (IBAction)textFieldEndEdit:(UITextField *)sender {
    
    
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.textField.text.length == 0) {
        BYShowError(@"请输入设备编号");
        return;
    }
    [self deviceCheck:self.textField.text];
    
}

#pragma mark -- 设备检测
- (void)deviceCheck:(NSString *)deviceStr{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceSn"] = deviceStr;
    
    [BYSendWorkHttpTool POSTDeviceCheckParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model = [BYInstallDeviceCheckModel yy_modelWithDictionary:data];
            if (!weakSelf.model.groupId) {
                BYShowError(@"设备所在组为空");
                return ;
            }
            if (weakSelf.model.deviceStatus == 2) {
                BYShowError(weakSelf.model.exceptionMsg);
                return;
            }
            [weakSelf refreshData];
            
        });
        
    } failure:^(NSError *error) {
      
        
    }];
}

- (void)refreshData{
    if (self.model.deviceSn.length) {
//        BYInstallDeviceCheckViewController *vc = [[BYInstallDeviceCheckViewController alloc] init];
//        vc.model = self.model;
//        [self.navigationController pushViewController:vc animated:YES];
        if (self.handInputBlock) {
            self.handInputBlock(self.model);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
