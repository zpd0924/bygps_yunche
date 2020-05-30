//
//  BYInstallSendOrderController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallSendOrderController.h"
#import "EasyNavigation.h"
#import "BYWorkMessageController.h"
#import "BYMyWorkOrderController.h"
#import "BYMyEvaluationViewController.h"
#import "BYMyEvaluationCommitViewController.h"
#import "BYAddCarInfoViewController.h"
#import "BYInstallSendOrderView.h"
#import "BYInstallSendOrderCountModel.h"
#import "BYCarTypeViewController.h"
#import "BYBelongCompanyViewController.h"
#import "BYMyEvaluationViewController.h"
#import "BYSendOrderResultViewController.h"
#import "BYAutoScanViewController.h"

@interface BYInstallSendOrderController ()

@property (nonatomic,strong) BYInstallSendOrderCountModel *sendOrderCountModel;
@property (nonatomic,weak) BYInstallSendOrderView *installSendOrderView;
@end

@implementation BYInstallSendOrderController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
//     [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self initBase];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initBase{
    BYWeakSelf;
   
    [self.navigationView setTitle:@"装机派"];
    self.view.backgroundColor = BYBackViewColor;
    BYInstallSendOrderView *installSendOrderView = [BYInstallSendOrderView by_viewFromXib];
    self.installSendOrderView = installSendOrderView;
    installSendOrderView.frame = CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - SafeAreaTopHeight);
    [self.view addSubview:installSendOrderView];
    [installSendOrderView.installSendOrderBtn addTarget:self action:@selector(installSendOrderViewClick) forControlEvents:UIControlEventTouchUpInside];
     [installSendOrderView.unpackSendOrderBtn addTarget:self action:@selector(unpackSendOrderViewClick) forControlEvents:UIControlEventTouchUpInside];
     [installSendOrderView.repairSendOrderBtn addTarget:self action:@selector(repairSendOrderViewClick) forControlEvents:UIControlEventTouchUpInside];
     UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSendOrderViewClick)];
     UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(missSendOrderViewClick)];
     UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overTimeSendOrderViewClick)];
     UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waiteSendOrderViewClick)];

    [installSendOrderView.sendOrderMyView addGestureRecognizer:tap7];
    [installSendOrderView.sendOrderMyAllView addGestureRecognizer:tap4];
    
//    [installSendOrderView.allSendOrderView addGestureRecognizer:tap4];
//    [installSendOrderView.missSendOrderView addGestureRecognizer:tap5];
//     [installSendOrderView.overTimeSendOrderView addGestureRecognizer:tap6];
//     [installSendOrderView.waiteSendOrderView addGestureRecognizer:tap7];
    
}

#pragma mark -- 获取工单数量数据
//- (void)loadData{
//    BYWeakSelf;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
//    [BYSendWorkHttpTool POSTAppointOrderCountParams:dict success:^(id data) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.sendOrderCountModel = [[BYInstallSendOrderCountModel alloc] initWithDictionary:data error:nil];
//            [weakSelf refreshData];
//        });
//
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark -- 刷新数据
//- (void)refreshData{
//    self.installSendOrderView.allCountLabel.text = [NSString stringWithFormat:@"%zd",_sendOrderCountModel.all];
//    self.installSendOrderView.noCountLabel.text = [NSString stringWithFormat:@"%zd",_sendOrderCountModel.un];
//    self.installSendOrderView.overTimeCountLabel.text = [NSString stringWithFormat:@"%zd",_sendOrderCountModel.overtime];
//    self.installSendOrderView.waitCountLabel.text = [NSString stringWithFormat:@"%zd",_sendOrderCountModel.isNotuditing];
//}
#pragma mark -- 安装派单
- (void)installSendOrderViewClick{
    BYWorkMessageController *vc = [[BYWorkMessageController alloc] init];
    vc.sendOrderType = BYWorkSendOrderType;
    vc.titleLabelStr = @"安装派单";
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_install_send", @"");
//    BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
//    vc.titleStr = @"派单成功";
//    vc.resultType = 1;
//
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 拆机派单
- (void)unpackSendOrderViewClick{
    BYWorkMessageController *vc = [[BYWorkMessageController alloc] init];
    vc.sendOrderType = BYUnpackSendOrderType;
    vc.titleLabelStr = @"拆机派单";
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_down_send", @"");
}
#pragma mark -- 检修派单
- (void)repairSendOrderViewClick{
    BYWorkMessageController *vc = [[BYWorkMessageController alloc] init];
    vc.sendOrderType = BYRepairSendOrderType;
    vc.titleLabelStr = @"检修派单";
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_recovery_send", @"");
}
#pragma mark -- 自助派单
- (void)autoinstallViewClick{
    BYAutoScanViewController *scanner = [[BYAutoScanViewController alloc] init];
    scanner.scanType = WQCodeScannerTypeBarcode;
    [self.navigationController pushViewController:scanner animated:YES];
}
#pragma mark -- 全部工单
- (void)allSendOrderViewClick{
    BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
    vc.row = 0;
    vc.model = _sendOrderCountModel;
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_my", @"");
}
#pragma mark -- 未接工单
- (void)missSendOrderViewClick{
    BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
    vc.row = 3;
    vc.model = _sendOrderCountModel;
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_wait", @"");
}
#pragma mark -- 超时工单
- (void)overTimeSendOrderViewClick{
    BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
    vc.row = 0;
    vc.isOverTime = YES;
    vc.model = _sendOrderCountModel;
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_time_out", @"");
}
#pragma mark -- 待审核工单
- (void)waiteSendOrderViewClick{
    BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
    vc.row = 1;
    vc.model = _sendOrderCountModel;
    [self.navigationController pushViewController:vc animated:YES];
    MobClickEvent(@"install_review", @"");
}


- (IBAction)myWorkOrderClick:(UIButton *)sender {
//    BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    BYMyEvaluationViewController *vc = [[BYMyEvaluationViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
   
}



@end
