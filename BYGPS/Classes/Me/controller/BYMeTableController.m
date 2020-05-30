//
//  BYMeTableController.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYMeTableController.h"
#import "BYSettingGroup.h"
#import "BYSettingArrowItem.h"
#import "BYMeHeaderView.h"
#import "BYAboutViewController.h"
#import "BYSettingViewController.h"
#import "BYLoginViewController.h"
#import "BYDetailTabBarController.h"
#import "BYLoginHttpTool.h"
#import "BYAlertView.h"
#import "EasyNavigation.h"
#import "BYCurrentPhoneBindingController.h"

@interface BYMeTableController ()

@property(nonatomic,strong)BYAlertView * tipAlertView;

@end

@implementation BYMeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setupGroup];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![BYSaveTool isContainsKey:BYSelfClassName]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYGuideImageView showGuideViewWith:BYSelfClassName touchOriginYScale:0.55];
        });
    }
}

-(void)initBase{

    self.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.navigationOrginalHeight)];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"个人中心"];
    self.BYTableViewCellStyle = UITableViewCellStyleValue1;
    self.tableView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight)];
    self.tableView.tableHeaderView = head;
}

-(void)setupGroup{
    [self.groups removeAllObjects];
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    BYSettingArrowItem * item1 = [BYSettingArrowItem itemWithImage:@"user_icon_star" title:@"关于"];
    item1.descVc = [BYAboutViewController class];
    
    BYSettingArrowItem * item2 = [BYSettingArrowItem itemWithImage:@"user_icon_set" title:@"设置"];
    item2.descVc = [BYSettingViewController class]; 
    
    BYSettingArrowItem * item3 = [BYSettingArrowItem itemWithImage:@"user_icon_phone" title:@"手机号绑定"];
    item3.descVc = [BYCurrentPhoneBindingController class];
    if ([BYSaveTool boolForKey:BYVisitorGroup]) {//是散户
        group.items = @[item1,item2];
    }else{
        group.items = @[item1,item2,item3];
    }
    
    [self.groups addObject:group];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BYMeHeaderView * header = [BYMeHeaderView by_viewFromXib];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(95);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:15 backgroundColor:UIColorHexFromRGB(0x1B66E5) title:@"退出" target:self action:@selector(logout)];
    [view addSubview:button];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(80);
}
-(void)logout{
    MobClickEvent(@"me_out", @"");
    [self.tipAlertView show];
}

-(void)logoutAction{
    [BYLoginHttpTool POSTLogoutSuccess:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [BYSaveTool setBool:NO forKey:BYLoginState];
            [BYSaveTool removeObjectForKey:BYToken];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
             BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
            EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        });
    }];
}
-(BYAlertView *)tipAlertView{
    
    if (_tipAlertView == nil) {
        _tipAlertView = [BYAlertView viewFromNibWithTitle:@"警告" message:nil];
        _tipAlertView.alertHeightContraint.constant = BYS_W_H(80 + 80);
        _tipAlertView.alertWidthContraint.constant = BYS_W_H(220);
        
        UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(BYS_W_H(40) / 2, 0, BYS_W_H(180), BYS_W_H(80))];
        messageLabel.numberOfLines = 0;
        messageLabel.text = @"注销后将收不到报警通知,确定要取消吗?";
        messageLabel.font = BYS_T_F(14);
        messageLabel.textColor = BYRGBColor(46, 46, 46);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        BYWeakSelf;
        [_tipAlertView setSureBlock:^{
            
            [weakSelf logoutAction];
            _tipAlertView = nil;
        }];
        
        [_tipAlertView setCancelBlock:^{
            _tipAlertView = nil;
        }];
        
        [_tipAlertView.contentView addSubview:messageLabel];
        
    }
    return _tipAlertView;
}

@end







