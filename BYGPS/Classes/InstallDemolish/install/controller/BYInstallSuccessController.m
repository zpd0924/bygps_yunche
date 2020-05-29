//
//  BYInstallSuccessController.m
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallSuccessController.h"
#import "EasyNavigation.h"
@interface BYInstallSuccessController ()
@property (weak, nonatomic) IBOutlet UIButton *keepInstallButton;

@end

@implementation BYInstallSuccessController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.disableSlidingBackGesture = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    if (self.functionType == BYFunctionTypeRemove) {
//        [self.navigationView setTitle:@"拆机成功"];
//        [self.keepInstallButton setTitle:@"继续" forState:UIControlStateNormal];
//    }else if(self.functionType == BYFunctionTypeRepair){
//        [self.navigationView setTitle:@"检修成功"];
//        [self.keepInstallButton setTitle:@"继续" forState:UIControlStateNormal];
//    }else{
        [self.navigationView setTitle:@"安装成功"];
        [self.keepInstallButton setTitle:@"继续安装" forState:UIControlStateNormal];
//    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationView removeAllLeftButton];
    });
    
    self.navigationController.disableSlidingBackGesture = YES;
//    self.navigationItem.leftBarButtonItem = nil;
}
- (IBAction)keepInstallAction:(id)sender {
    //用于装机成功后返回到设备列表要求刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:BYDemolishInstallSuccessNotifiKey object:nil];
    [self.navigationController popToViewController:self animated:YES];
    
}

@end
