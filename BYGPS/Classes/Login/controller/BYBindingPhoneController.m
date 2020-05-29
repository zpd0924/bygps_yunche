//
//  BYBindingPhoneController.m
//  BYGPS
//
//  Created by miwer on 2017/4/24.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBindingPhoneController.h"
#import "BYSettingGroup.h"
#import "BYSettingTextFieldItem.h"
#import "BYCodeItem.h"
#import "BYRegularTool.h"
#import "BYTabBarController.h"
#import "BYLoginHttpTool.h"
#import "BYBindPhoneTextFieldCell.h"
#import "EasyNavigation.h"

@interface BYBindingPhoneController ()
{
    BYSettingTextFieldItem * _item1;
    BYCodeItem * _item2;
}

@property (nonatomic,strong) NSString * phoneNum;
@property (nonatomic,strong) NSString * code;
//@property (nonatomic,strong) BYVerifyCodeButton *codeButton;

@end

@implementation BYBindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    [self setupGroup];
}

-(void)initBase{
    [self.navigationView setTitle: self.isChangePhone ? @"更换手机号" : @"绑定手机号"];
    self.BYTableViewCellStyle = UITableViewCellStyleDefault;
    self.tableView.frame = CGRectMake(0, 0, BYSCREEN_W, BYSCREEN_H);
//    self.tableView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
//        BYLog(@"%f",SafeAreaTopHeight);
        
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 64)];
//    self.tableView.tableHeaderView = head;
}
-(void)setupGroup{
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    
    _item1 = [[BYSettingTextFieldItem alloc] init];
    _item1.cellPlaceholder = self.isChangePhone ? @"请输入新的手机号" : @"请输入要绑定的手机号";
    _item1.isSecurity = NO;
    _item1.keyboardType = UIKeyboardTypePhonePad;
    _item1.title = @"+86";
    _item2 = [[BYCodeItem alloc] init];
    _item2.title = @"验证码";
    _item2.isAble = NO;
    BYWeakSelf;
    [_item1 setEndEditCallBack:^(NSString *input) {
        weakSelf.phoneNum = input;
    }];
    
    [_item2 setEndEditCallBack:^(NSString *input) {
        
        weakSelf.code = input;
        
    }];
    group.items = @[_item1,_item2];
    [self.groups addObject:group];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell,设置cellStyle
    BYBindPhoneTextFieldCell *cell = [BYBindPhoneTextFieldCell cellWithTableView:tableView tableViewCellStyle:self.BYTableViewCellStyle];
    
    // 获取对应的组模型
    BYSettingGroup *group = self.groups[indexPath.section];
    
    // 获取模型
    BYBaseSettingItem *item = group.items[indexPath.row];
    
    // 给cell传递一个模型
    cell.item = item;
    
    if (indexPath.row == 1) {
        __weak typeof(cell) weakCell = cell;
        [cell setCodeButtonCallBack:^{
            [self.view endEditing:YES];
            if (![BYRegularTool validatePhone:self.phoneNum]) {
                return BYShowError(@"请输入正确的手机号码");
            }
//            BYWeakSelf;
            [BYLoginHttpTool POSTMessageCodeWithMobile:self.phoneNum success:^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYShowSuccess(@"发送成功");
                    [weakCell.codeButton timeFailBegin];
//                    weakSelf.codeButton = weakCell.codeButton;
                });
                
            } failure:^(NSError *error) {
            
            }];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:19 backgroundColor:BYGlobalBlueColor title:self.isChangePhone ? @"确认修改" : @"立即绑定" target:self action:@selector(binding)];
    [view addSubview:button];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(80);
}

-(void)binding{
    [self.view endEditing:YES];
    
    if (![BYRegularTool validatePhone:self.phoneNum]) {
        return BYShowError(@"请输入正确的手机号码");
    }
    
    if (self.isChangePhone) {
        //修改手机号
        [BYLoginHttpTool PostBindMobileWithMobile:self.phoneNum code:self.code Success:^(id data) {
            [BYSaveTool setValue:self.phoneNum forKey:mobile];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
        return;
    }else{
        //绑定手机号
        [BYLoginHttpTool PostBindMobileWithMobile:self.phoneNum code:self.code Success:^(id data) {
            
            [BYSaveTool setValue:self.phoneNum forKey:mobile];
            dispatch_async(dispatch_get_main_queue(), ^{
                BYTabBarController * tabBarVC = [[BYTabBarController alloc] init];
                tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                tabBarVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:tabBarVC animated:YES completion:nil];
                
                UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                
                if ([vc isKindOfClass:[EasyNavigationController class]]) {
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
                }
            });
        }];
        
    }
    BYLog(@"phone : %@ -- code : %@",self.phoneNum,self.code);
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//
//-(void)dealloc
//{
//    BYVerifyCodeButton *codebutton = (BYVerifyCodeButton *)self.codeButton;
//    [codebutton cancelTimer];
//
//}

@end
