//
//  BYSelfServiceInstallSuccessViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/9/11.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSelfServiceInstallSuccessViewController.h"
#import "EasyNavigation.h"
#import "BYAutoScanViewController.h"
#import "BYInstallRecordViewController.h"

@interface BYSelfServiceInstallSuccessViewController ()

@end

@implementation BYSelfServiceInstallSuccessViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.disableSlidingBackGesture = YES;
    BYWeakSelf;
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
//    });
}
- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"安装成功"];
    self.navigationController.disableSlidingBackGesture = YES;
    //    self.navigationItem.leftBarButtonItem = nil;
}
- (IBAction)continueInstall:(id)sender {
    
    BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)checkBeenInstall:(id)sender {
    
    BYInstallRecordViewController *vc = [[BYInstallRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
