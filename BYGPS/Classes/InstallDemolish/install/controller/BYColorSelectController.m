//
//  BYColorSelectController.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYColorSelectController.h"
#import "EasyNavigation.h"

@interface BYColorSelectController ()

@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@end

@implementation BYColorSelectController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
    [self.navigationView setTitle:@"选择颜色"];
    self.view.backgroundColor = BYBackViewColor;
//    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
 
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.topH.constant = SafeAreaTopHeight;

    
   
    

    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_arr_left_white" target:self action:@selector(backAction)];
//    self.navigationController.navigationBar.barTintColor = BYGlobalBlueColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.whiteButton.layer.borderWidth = 1;
    self.whiteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (IBAction)colorItemSelect:(UIButton *)sender {
    if (self.colorItemSelectBlock) {
        self.colorItemSelectBlock(sender.tag - 80);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
