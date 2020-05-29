//
//  BYLoginViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYLoginViewController.h"
#import "BYTabBarController.h"
#import "BYLoginDatabase.h"
#import "BYUserModel.h"
#import "BYBindingPhoneController.h"
#import "BYBindingCdaController.h"
#import "EasyNavigation.h"

#import "BYNetworkHelper.h"
#import "BYLoginHttpTool.h"

#import "BYWXManagerTool.h"

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

#import "NSString+BYAttributeString.h"
#import "BYRouteModel.h"
#import "BYRouteDefModel.h"
#import "BYRouteApisModel.h"
#import "BYAlertTip.h"
#import "BYVerUpdateModel.h"
#import "BYPrivacyViewController.h"
#import "BYRegisterViewController.h"
#import "BYCodeReminderViewController.h"
#import "BYDateFormtterTool.h"
static NSString * const ID = @"cell";
static NSString * const weiXinJudgeUrl = @"user/queryWeixin.do";

@interface BYLoginViewController () <UITableViewDataSource,UITableViewDelegate,WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *remeberButton;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *usersTableButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropImageViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *WXLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *wxLoginLabel;
@property (weak, nonatomic) IBOutlet UIView *WXLoginView1;
@property (weak, nonatomic) IBOutlet UIView *WXLoginView2;

//根据屏幕需要修改的约束属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBgConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LoginBtnHConstraint;//54

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHContraint;//135
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoWContraint;//175


@property (weak, nonatomic) IBOutlet UIView *tableBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSIndexPath * currentIndexPath;

@property (weak, nonatomic) IBOutlet UIImageView *dropImageView;

//数据源
@property(nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) BYRouteModel *routeModel;///寻址模型
@property (nonatomic,strong) BYVerUpdateModel *updateModel;
@end

@implementation BYLoginViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    BYStatusBarDefault;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendAuthRespResponseNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isAutoLogin) {
        BYTabBarController * tabBarVC = [[BYTabBarController alloc] init];
//        tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        tabBarVC.selectedIndex = 0;
//        [self presentViewController:tabBarVC animated:YES completion:nil];
        
        UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([vc isKindOfClass:[EasyNavigationController class]]) {
            
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        }
    }
//    BYStatusBarLight;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeWXWithNotifi:) name:@"sendAuthRespResponseNotification" object:nil];
    
    [self.dataSource removeAllObjects];
    //获取用户数据源
    [self.dataSource addObjectsFromArray:[[BYLoginDatabase shareInstance] queryAllUser]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
   
  
    if (![BYSaveTool objectForKey:BYBaseUrl]) {
        [self loadRoute];
    }
  
    [self verUpdate];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initBase];
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verLowsNotifi:) name:@"verLowsNotifi" object:nil];
    [BYSaveTool setValue:nil forKey:BYHandSetRouteUrl];
   
    [self privacyTip];
    
}

///隐私政策
- (void)privacyTip{
    BYWeakSelf;
    NSString* version= @"CFBundleVersion";
    NSString* last= [[NSUserDefaults standardUserDefaults]objectForKey:version] ;
    NSString* current= [NSBundle mainBundle].infoDictionary[version];
    if (![current isEqualToString:last]) {
        [[NSUserDefaults standardUserDefaults]setObject:current forKey:version];

        [BYAlertTip ShowOnlySureAlertWith:@"隐私政策" message:@"新增隐私政策,请您查看并同意,以便更好的行使权利及保护个人信息" sureTitle:@"查看并同意" viewControl:self andSureBack:^{
            BYPrivacyViewController *vc =[[BYPrivacyViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
   

}

///版本升级
- (void)verLowsNotifi:(NSNotification *)note{
    BYLog(@"%@",note.userInfo);
    [BYAlertTip ShowOnlyAlertWith:@"升级提示" message:@"请升级版本" viewControl:self andSureBack:^{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:note.userInfo[@"goToUrl"]]];
    }];
    
}
#pragma mark -- 版本升级
- (void)verUpdate{
    BYWeakSelf;
    [BYLoginHttpTool POSTUpdateWithUserNameSuccess:^(id data) {
        BYLog(@"update = %@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.updateModel = [[BYVerUpdateModel alloc] initWithDictionary:data[@"reply"] error:nil];
            if(!weakSelf.updateModel.flag)
                return;
            if(weakSelf.updateModel.isForce){
                
                
                [BYAlertTip ShowOnlyAlertWith:@"升级提示" message:weakSelf.updateModel.Description viewControl:weakSelf andSureBack:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.updateModel.fileUrl]];
                }];
                
                
            }else{
//                if([BYObjectTool isFirstGoInApp]){
                    [BYAlertTip ShowAlertWith:@"升级提示" message:weakSelf.updateModel.Description withCancelTitle:@"取消" withSureTitle:@"确定" viewControl:self andSureBack:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.updateModel.fileUrl]];
                    } andCancelBack:^{
                        
                    }];
//                }
            }
            
        });
    }];
}
///寻址
- (void)loadRoute{
    BYWeakSelf;
    [[BYNetworkHelper sharedInstance] POSTRouteUrlWithSuccess:^(id data) {
        BYLog(@"%@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.routeModel = [BYRouteModel yy_modelWithDictionary:data];
            
            
            NSString *portStr = weakSelf.routeModel.defaults.port;
            if (portStr.length) {
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@:%@/by-app-web/",weakSelf.routeModel.defaults.host,weakSelf.routeModel.defaults.port];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }else{
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@/by-app-web/",weakSelf.routeModel.defaults.host];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }
            for (BYRouteApisModel *model in weakSelf.routeModel.apis) {
                if ([model.apiName isEqualToString:@"command-h5"]) {
                    NSString *baseH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@/%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],@"dist-html"];
                    [BYSaveTool setValue:baseH5Url forKey:BYH5Url];
                    
                }
                if ([model.apiName isEqualToString:@"privacy-h5"]) {

                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
        
                    [BYSaveTool setValue:basePravacyH5Url forKey:BYPrivacyH5Url];
                }
                if ([model.apiName isEqualToString:@"umscollector"]){
                    NSString *umscollectorUrl = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                   
                    
                    [BYSaveTool setValue:umscollectorUrl forKey:BYUmscollectorUrl];
                    
                }
            }
          
           
        });
       
       
       
    } failure:^(NSError *error) {
        
    } showError:NO];
}

-(void)initBase{

    self.navigationView.hidden = YES;
    
    if (BYiPhone5_OR_5c_OR_5s) {
        self.LoginBtnHConstraint.constant = 44;
    }else if (BYiPhone6_OR_6s){
        self.LoginBtnHConstraint.constant = 54;
    }else if (BYiPhone6Plus_OR_6sPlus){
        self.LoginBtnHConstraint.constant = 60;
    }
    self.logoWContraint.constant = 175 * BYSCREEN_W / 375;
    self.logoHContraint.constant = 135 * (BYSCREEN_H / 667 > 1 ? 1 : BYSCREEN_H / 667);
    
    if (![BYSaveTool boolForKey:BYWXIsStall]) {
        self.WXLoginButton.hidden = YES;
//        self.WXLoginView.hidden = YES;
        self.wxLoginLabel.hidden = YES;
        self.WXLoginView1.hidden = YES;
        self.WXLoginView2.hidden = YES;
    }

    
    //tableView的背景View高度约束为0
    self.tableBgConstraint.constant = 0;
    self.dropImageViewConstraint.constant = 0;
    self.remeberButton.selected = [BYSaveTool isContainsKey:remeberPassword] ? [BYSaveTool boolForKey:remeberPassword] : YES;
    self.autoLoginButton.selected = [BYSaveTool boolForKey:remeberAutoLogin];
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.clipsToBounds = YES;
    
    self.usernameTextField.text = [BYSaveTool valueForKey:BYusername];
    self.passwordTextField.text = [BYSaveTool valueForKey:BYpassword];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账号/手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

//    [self.usernameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    ///增加测试调试手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapClick)];
    //设置属性 点击此次 1单击 2双击
    tap.numberOfTapsRequired = 10;
    //设置属性 单击触控 还是多点触控
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}
- (void)TapClick{
    
    BYWeakSelf;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"开发环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       [BYSaveTool setValue:@"dev" forKey:BYHandSetRouteUrl];
        [weakSelf loadRoute];
    }];
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"测试环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [BYSaveTool setValue:@"test" forKey:BYHandSetRouteUrl];
         [weakSelf loadRoute];
    }];
    UIAlertAction *Action3 = [UIAlertAction actionWithTitle:@"预发布环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [BYSaveTool setValue:@"demo" forKey:BYHandSetRouteUrl];
         [weakSelf loadRoute];
    }];
    UIAlertAction *Action4 = [UIAlertAction actionWithTitle:@"生产环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [BYSaveTool setValue:@"release" forKey:BYHandSetRouteUrl];
         [weakSelf loadRoute];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:Action1];
    [alertController addAction:Action2];
    [alertController addAction:Action3];
    [alertController addAction:Action4];
    if ([BYObjectTool getIsIpad]){
        
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)login:(id)sender {

//    //注册页面测试
//    BYRegisterViewController *vc = [[BYRegisterViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self loginWithUserName:self.usernameTextField.text passWord:self.passwordTextField.text sourceFlag:1];
}

-(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord sourceFlag:(NSInteger)sourceFlag
{
    [self hidenTableView];
    
    BYWeakSelf;
    [BYLoginHttpTool PostLogin:userName password:passWord sourceFlag:sourceFlag Success:^(id data) {
        BYLog(@"%@",data);
         [BYSaveTool setBool:YES forKey:BYLoginState];
        double loginDateTime = [BYDateFormtterTool getNowTimestamp];
        
        NSString *loginDateTimeStr = [NSString stringWithFormat:@"%f",loginDateTime];
        [BYSaveTool setObject:loginDateTimeStr forKey:BYLoginDateTime];
    
        if (sourceFlag == 1) {
            [weakSelf saveForLogin];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:BYRepeatLoginKey object:nil];//当重复登录时,发送通知到首页,让菊花重现
        
        dispatch_async(dispatch_get_main_queue(), ^{
                BYTabBarController * tabBarVC = [[BYTabBarController alloc] init];
                tabBarVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                tabBarVC.modalPresentationStyle = UIModalPresentationFullScreen;
                tabBarVC.selectedIndex = 0;
                    
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        });
    } showError:YES];
}


-(void)saveForLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        //记住是否记住密码和自动登录状态存入到NSUserDefaults
        [BYSaveTool setBool:self.remeberButton.selected forKey:remeberPassword];
        [BYSaveTool setBool:self.autoLoginButton.selected forKey:remeberAutoLogin];
        
        //如果记住密码,保存用户名和密码
        NSString * passwordStr = @"";
        if (self.remeberButton.selected) {
            //是否登陆过
            NSMutableArray * loginUsers = [[BYLoginDatabase shareInstance] queryUsersWithUsername:self.usernameTextField.text];
            
            if (loginUsers.count > 0) {
                
                [[BYLoginDatabase shareInstance] updateUserForLoginTime:self.usernameTextField.text];
                BYUserModel * user = [loginUsers firstObject];
                
                if (![user.password isEqualToString:self.passwordTextField.text]) {
                    [[BYLoginDatabase shareInstance] updateUserForUsername:self.usernameTextField.text password:self.passwordTextField.text];
                }
            }else{
                [[BYLoginDatabase shareInstance] insertUser:self.usernameTextField.text password:self.passwordTextField.text];
            }
            
            passwordStr = self.passwordTextField.text;
            
        }else{
            
            [[BYLoginDatabase shareInstance] deleteUser:self.usernameTextField.text];
        }
        [BYSaveTool setValue:self.usernameTextField.text forKey:BYusername];
//        [BYSaveTool setValue:self.usernameTextField.text forKey:loginName];
        [BYSaveTool setValue:passwordStr forKey:BYpassword];
    });
}

- (IBAction)remeberPassword:(id)sender {
    self.remeberButton.selected = !self.remeberButton.selected;
    if (!self.remeberButton.selected) {
        self.autoLoginButton.selected = NO;
    }
}
- (IBAction)autoLogin:(id)sender {
    self.autoLoginButton.selected = !self.autoLoginButton.selected;
    if (self.autoLoginButton.selected) {
        self.remeberButton.selected = YES;
    }
}
- (IBAction)usersTable:(id)sender {
    self.usersTableButton.selected = !self.usersTableButton.selected;
    
    NSInteger count = self.dataSource.count >= 3 ? 3 : self.dataSource.count;
    self.tableBgConstraint.constant = self.usersTableButton.selected ? count * 44 : 0;
    self.dropImageViewConstraint.constant = self.usersTableButton.selected ? 6 : 0;
}

#pragma mark -- 注册
- (IBAction)regisBtnClick:(UIButton *)sender {
    MobClickEvent(@"longing_register", @"");
    BYRegisterViewController *vc = [[BYRegisterViewController alloc] init];
    vc.registerType = BYRegisType;
    BYWeakSelf;
    vc.registerBlock = ^(NSString *phone, NSString *password) {
//        weakSelf.usernameTextField.text = phone;
//        weakSelf.passwordTextField.text = password;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 忘记密码
- (IBAction)forgetPasswordBtnClick:(UIButton *)sender {
    BYRegisterViewController *vc = [[BYRegisterViewController alloc] init];
    vc.registerType = BYforgetPasswordType;
    [self.navigationController pushViewController:vc animated:YES];
}


//微信登录
- (IBAction)wechat:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        [self sendAuthRequest];
    }else{
        BYShowError(@"请先安装微信");
    }
}
//微信授权登录
- (void)sendAuthRequest {
    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc ] init ];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    req.openID = BYWXAppId;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
    
    [WXApiRequestHandler sendAuthRequestScope: BYWXScope
                                        State:BYWXState
                                       OpenID:BYWXAppId
                             InViewController:self];
}
-(void)judgeWXWithNotifi:(NSNotification *)note{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"wxOpenId"] = [[note userInfo] valueForKey:@"openid"];
    
    [BYWXManagerTool PostQueryWeixinWithWeixin:[[note userInfo] valueForKey:@"openid"] Success:^(id data) {
        if ([data isKindOfClass:[NSNull class]]) {
//            12000018
            dispatch_async(dispatch_get_main_queue(), ^{
                //微信未绑定，进入绑定页面
                BYBindingCdaController * bindingCdaVc = [[BYBindingCdaController alloc] init];
                bindingCdaVc.isLogout = self.isLogout;
                [self.navigationController pushViewController:bindingCdaVc animated:YES];
            });

        }else{
            //已绑定微信，获取本地保存用户名和密码
            //                NSString *userDataStr = [BYSaveTool valueForKey:BYWXOpenUserData];
            //                NSDictionary *dic = [NSString dictionaryWithJsonString:userDataStr];
            //              要删除
            [self loginWithUserName:nil passWord:nil sourceFlag:2];
            }
    }];
}


#pragma mark - <UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    UIButton * accessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessButton setImage:[UIImage imageNamed:@"login_icon_close"] forState:UIControlStateNormal];
//    [accessButton sizeToFit];
//    accessButton.backgroundColor = [UIColor redColor];
    accessButton.by_size = CGSizeMake(30, 30);
    accessButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    accessButton.tag = indexPath.row;
    [accessButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = accessButton;
    
    BYUserModel * user = self.dataSource[indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYUserModel * user = self.dataSource[indexPath.row];
    self.usernameTextField.text = user.username;
    self.passwordTextField.text = user.password;
    
    [self hidenTableView];
}

-(void)hidenTableView{
    self.tableBgConstraint.constant = 0;
    self.dropImageViewConstraint.constant = 0;
    self.usersTableButton.selected = NO;
}

-(void)deleteUser:(UIButton *)button{
    
    BYUserModel * user = self.dataSource[button.tag];
    [[BYLoginDatabase shareInstance] deleteUser:user.username];
    [self.dataSource removeObjectAtIndex:button.tag];
    if ([user.username isEqualToString:self.usernameTextField.text]) {
        self.usernameTextField.text = nil;
        self.passwordTextField.text = nil;
    }
    NSInteger count = self.dataSource.count >= 3 ? 3 : self.dataSource.count;
    self.tableBgConstraint.constant = self.usersTableButton.selected ? count * 44 : 0;
    if (count == 0) {
        self.usersTableButton.selected = NO;
    }
    
    [self.tableView reloadData];
}
#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidenTableView];
    
    [self.view endEditing:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendAuthRespResponseNotification" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"verLowsNotifi" object:nil];
}

@end







