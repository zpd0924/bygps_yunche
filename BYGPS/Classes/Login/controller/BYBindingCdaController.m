//
//  BYBindCdaController.m
//  BYGPS
//
//  Created by miwer on 2017/4/25.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBindingCdaController.h"
#import "EasyNavigation.h"
#import "BYLoginHttpTool.h"

#import "BYSettingGroup.h"
#import "BYSettingTextFieldItem.h"
#import "BYCodeItem.h"
#import "BYRegularTool.h"
#import "BYTabBarController.h"
#import "BYBindingPhoneController.h"
#import "EasyNavigation.h"

#import "NSString+BYAttributeString.h"

@interface BYBindingCdaController ()

@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * passWord;
@property (nonatomic,assign) BOOL isBindWX;

@end

@implementation BYBindingCdaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    [self setupGroup];
}

-(void)initBase{
    [self.navigationView setTitle:@"绑定标越科技账号"];
    self.BYTableViewCellStyle = UITableViewCellStyleDefault;
    self.tableView.frame = CGRectMake(0, 64, BYSCREEN_W, BYSCREEN_H - 64);
    if (@available(iOS 11.0, *)) {
        
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)setupGroup{
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    
    BYSettingTextFieldItem * item1 = [[BYSettingTextFieldItem alloc] init];
    item1.cellPlaceholder = @"请输入账号";
    item1.isSecurity = NO;
    item1.keyboardType = UIKeyboardTypeDefault;
    item1.title = @"账号";
    [item1 setEndEditCallBack:^(NSString *input) {
        
        self.userName = input;
    }];
    
    BYSettingTextFieldItem * item2 = [[BYSettingTextFieldItem alloc] init];
    item2.title = @"密码";
    item2.cellPlaceholder = @"请输入密码";
    item2.isSecurity = YES;
    item2.keyboardType = UIKeyboardTypeDefault;
    [item2 setEndEditCallBack:^(NSString *input) {
        self.passWord = input;
    }];
    
    group.items = @[item1,item2];
    [self.groups addObject:group];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:19 backgroundColor:BYGlobalBlueColor title:@"立即绑定" target:self action:@selector(binding)];
    [view addSubview:button];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(80);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"    为账户安全需先绑定标越科技账号";
    label.textColor = [UIColor colorWithHex:@"#999999"];
    label.font = BYS_T_F(14);
    
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(void)binding{
    [self.view endEditing:YES];
        //绑定微信号、账号
    [BYLoginHttpTool PostBindWeiXinWithLoginname:self.userName weixinOpenId:[BYSaveTool valueForKey:BYWeixinOpenId] password:self.passWord Success:^(id data) {
//        if ([data[@"bindFlag"] integerValue] == 1) {
        
            NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
            dict[@"userName"] = self.userName;
            dict[@"passWord"] = self.passWord;
            
            [BYSaveTool setValue:self.userName forKey:BYusername];
            [BYSaveTool setValue:self.passWord forKey:BYpassword];
            
            NSString *userStr = [NSString stringConvertToJsonData:dict];
            
            [BYSaveTool setValue:userStr forKey:BYWXOpenUserData];
            [self loginWithUserName:self.userName passWord:self.passWord sourceFlag:2];
//        }
//        if ([data[@"bindFlag"] integerValue] == 2) {
//            BYShowError(data[@"hint"]);
//        }
    }];

    BYLog(@"phone : %@ -- code : %@",self.userName ,self.passWord);
}
-(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord sourceFlag:(NSInteger)sourceFlag
{
    BYWeakSelf;
    [BYLoginHttpTool PostLogin:userName password:passWord sourceFlag:sourceFlag Success:^(id data) {
        BYLog(@"%@",data);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BYRepeatLoginKey object:nil];//当重复登录时,发送通知到首页,让菊花重现
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!(([data[@"isValid"] integerValue] == 1) && ![data[@"mobile"] isEqualToString:@""])) {
                BYBindingPhoneController * bindingPhoneVc = [[BYBindingPhoneController alloc] init];
                bindingPhoneVc.isLogout = self.isLogout;
                [self.navigationController pushViewController:bindingPhoneVc animated:YES];
                
                return ;
            }

                BYTabBarController * tabBarVC = [[BYTabBarController alloc] init];
//                tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                [weakSelf presentViewController:tabBarVC animated:YES completion:nil];
            
                UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                if ([vc isKindOfClass:[EasyNavigationController class]]) {
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
                }
        });
        
    } showError:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
