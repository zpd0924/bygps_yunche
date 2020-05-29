//
//  BYPasswordViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPasswordViewController.h"
#import "BYSettingGroup.h"
#import "BYSettingTextFieldItem.h"
#import "BYSettingCell.h"
#import "BYLoginHttpTool.h"
#import "BYLoginViewController.h"
#import "BYLoginDatabase.h"
#import "EasyNavigation.h"

#import <CommonCrypto/CommonDigest.h>

@interface BYPasswordViewController ()

@property(strong, nonatomic)UITextField * oldTextField;
@property(strong, nonatomic)UITextField * nowTextField;
@property(strong, nonatomic)UITextField * sureTextField;

@end

@implementation BYPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    [self setupGroup];
}

-(void)initBase{
    
    [self.navigationView setTitle:@"修改密码"];
    self.BYTableViewCellStyle = UITableViewCellStyleDefault;
    self.tableView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.tableView.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H);

}
-(void)setupGroup{
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    
    BYSettingTextFieldItem * item1 = [[BYSettingTextFieldItem alloc] init];
    item1.cellPlaceholder = @"请输入原始密码";
    item1.isSecurity = YES;
    item1.keyboardType = UIKeyboardTypeDefault;
    item1.title = @"原始密码";
    
    BYSettingTextFieldItem * item2 = [[BYSettingTextFieldItem alloc] init];
    item2.cellPlaceholder = @"请输入新设密码";
    item2.isSecurity = YES;
    item2.keyboardType = UIKeyboardTypeDefault;
    item2.title = @"新设密码";
    
    BYSettingTextFieldItem * item3 = [[BYSettingTextFieldItem alloc] init];
    item3.cellPlaceholder = @"请输入确认密码";
    item3.isSecurity = YES;
    item3.keyboardType = UIKeyboardTypeDefault;
    item3.title = @"确认密码";
    
    group.items = @[item1,item2,item3];
    
    [self.groups addObject:group];
    
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 创建cell,设置cellStyle
    BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView tableViewCellStyle:self.BYTableViewCellStyle];
    
    // 获取对应的组模型
    BYSettingGroup *group = self.groups[indexPath.section];
    
    // 获取模型
    BYBaseSettingItem *item = group.items[indexPath.row];
    
    // 给cell传递一个模型
    cell.item = item;
    
    switch (indexPath.row) {
        case 0:
            self.oldTextField = cell.textField;
            break;
        case 1:
            self.nowTextField = cell.textField;
            break;
        case 2:
            self.sureTextField = cell.textField;
            break;
            
        default:
            break;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:19 backgroundColor:[UIColor redColor] title:@"确认修改" target:self action:@selector(sureChange)];
    [view addSubview:button];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(80);
}

-(void)sureChange{
    
    NSString * oldPassword = [BYSaveTool valueForKey:BYpassword];
    if (oldPassword.length && ![self.oldTextField.text isEqualToString:oldPassword]) {
        return [BYProgressHUD by_showErrorWithStatus:@"原密码错误"];
    }
    
    if (self.oldTextField.text.length == 0 || self.nowTextField.text.length == 0 || self.sureTextField.text.length == 0) {
        
        return [BYProgressHUD by_showErrorWithStatus:@"输入不能为空"];
    }
    
    if ([self.oldTextField.text isEqualToString:self.nowTextField.text]) {
        
        return [BYProgressHUD by_showErrorWithStatus:@"改后密码与原密码相同"];
    }
    
    if (![self.nowTextField.text isEqualToString:self.sureTextField.text]) {
        
        return [BYProgressHUD by_showErrorWithStatus:@"密码不一致"];
    }

    BYWeakSelf;
    [BYLoginHttpTool POSTUpdatePasswordWithOld:self.oldTextField.text now:self.nowTextField.text success:^{
        
        [BYSaveTool setValue:@"" forKey:BYpassword];//修改密码让本地缓存的密码置空
        [[BYLoginDatabase shareInstance] updateUserForUsername:[BYSaveTool valueForKey:BYusername] password:@""];//同时更改数据库中的密码
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            BYLoginViewController * loginVc = [[BYLoginViewController alloc] init];
            loginVc.isLogout = YES;
            EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVc];
            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        });
    }];
}

- (NSString *)md5:(NSString *)str{//md5加密
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end



