//
//  BYAutoServiceSuccessViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/27.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceSuccessViewController.h"
#import "EasyNavigation.h"
#import "BYInfoController.h"

@interface BYAutoServiceSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *keepButton;
@property (weak, nonatomic) IBOutlet UILabel *successTitleLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation BYAutoServiceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationView.hidden = YES;
//    // Do any additional setup after loading the view from its nib.
//    self.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.navigationOrginalHeight)];
//    [self.view addSubview:self.navigationView];
    
//    [self.navigationView setTitle:@"个人中心"];
    if (self.functionType == BYFunctionTypeRemove) {

        [self.navItem setTitle:@"拆机成功"];
        self.successTitleLabel.text = @"恭喜,拆机信息提交成功";
        [self.keepButton setTitle:@"继续" forState:UIControlStateNormal];
    }else if(self.functionType == BYFunctionTypeRepair){
        [self.navItem setTitle:@"检修成功"];
        self.successTitleLabel.text = @"恭喜,检修信息提交成功";
        [self.keepButton setTitle:@"继续" forState:UIControlStateNormal];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//    });
    
    self.navigationController.disableSlidingBackGesture = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)keepRepairClick:(id)sender {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[BYInfoController class]]) {
            
            BYInfoController *vc = (BYInfoController *)controller;
            
            [self.navigationController popToViewController:vc animated:YES];
            
        }else if ([controller isKindOfClass:[BYAutoServiceSuccessViewController class]]){
            [self.navigationController popToViewController:self animated:YES];
        }
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
