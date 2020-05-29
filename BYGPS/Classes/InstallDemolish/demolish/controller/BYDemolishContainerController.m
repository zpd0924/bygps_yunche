//
//  BYDemolishListController.m
//  父子控制器
//
//  Created by miwer on 2016/12/16.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDemolishContainerController.h"
#import "BYReceivingListController.h"
#import "BYReceivedListController.h"
#import "BYAppointmentController.h"
#import "EasyNavigation.h"

#define DEMOLISH_H 50

@interface BYDemolishContainerController ()

@property(nonatomic,strong) UIButton * demolishButton;

@end

@implementation BYDemolishContainerController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BYStatusBarDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBase];

    [self.view addSubview:self.demolishButton];
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initBase{
    BYWeakSelf;
    [self.navigationView setTitle:@"拆机预约"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//    });
    
    
//    [self.navigationView.leftButton setImage:[UIImage imageNamed:@"icon_arr_left_white"] forState:UIControlStateNormal];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加所有子控制器
    [self setUpAllViewController];
    
    self.isfullScreen = YES;
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        
        *norColor = [UIColor whiteColor];
        *selColor = [UIColor whiteColor];
        *titleWidth = BYSCREEN_W / 2;
    }];
    
    // 标题渐变
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor blackColor];
        *selColor = BYGlobalBlueColor;
    }];
    
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        
        *underLineColor = BYGlobalBlueColor;
        *isUnderLineDelayScroll = NO;
        //        *isUnderLineEqualTitleWidth = YES;
    }];
    
}

// 添加所有子控制器
- (void)setUpAllViewController{
    
    BYReceivingListController * vc1 = [[BYReceivingListController alloc] init];
    vc1.title = @"待接订单";
    [self addChildViewController:vc1];

    BYReceivedListController * vc2 = [[BYReceivedListController alloc] initWithStyle:UITableViewStylePlain];
    vc2.title = @"已接订单";
    [self addChildViewController:vc2];
}

-(void)orderDemolish{
    
    BYAppointmentController * appointVc = [[BYAppointmentController alloc] init];
    [self.navigationController pushViewController:appointVc animated:YES];
}

#pragma mark - lazy
-(UIButton *)demolishButton{
    if (_demolishButton == nil) {
        _demolishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _demolishButton.frame = CGRectMake(20, BYSCREEN_H - 110, DEMOLISH_H, DEMOLISH_H);

//        _demolishButton.backgroundColor = [UIColor redColor];
        [_demolishButton setImage:[UIImage imageNamed:@"btn_ordered"] forState:UIControlStateNormal];
        [_demolishButton sizeToFit];
        [_demolishButton addTarget:self action:@selector(orderDemolish) forControlEvents:UIControlEventTouchUpInside];
        
//        _demolishButton.layer.cornerRadius = DEMOLISH_H / 2;
        
        _demolishButton.layer.shadowColor = BYGrayColor(234).CGColor;//shadowColor阴影颜色
        _demolishButton.layer.shadowOffset = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _demolishButton.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _demolishButton.layer.shadowRadius = DEMOLISH_H / 2;//阴影半径，默认3
    }
    return _demolishButton;
}

@end
