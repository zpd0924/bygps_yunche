//
//  BYDetailTabBarController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDetailTabBarController.h"
#import "BYInfoController.h"
#import "BYTrackController.h"
#import "BYDeviceSettingController.h"

@interface BYDetailTabBarController ()

@end

@implementation BYDetailTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BYStatusBarDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    BYStatusBarLight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self addAllViewControllers];
}

-(void)addAllViewControllers{
    
    [self addViewController:[[BYInfoController alloc] init] image:@"tab_icon_car_normal" selectedImage:@"tab_icon_car_on" title:@"信息"];

    
    [self addViewController:[[BYTrackController alloc] init] image:@"tab_icon_location_normal" selectedImage:@"tab_icon_location_on" title:@"追踪"];

    [self addViewController:[[BYDeviceSettingController alloc] init] image:@"tab_icon_set_normal" selectedImage:@"tab_icon_set_on" title:@"设置"];
    
}
- (void)addViewController:(UIViewController *)childViewController image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title{
    
    childViewController.tabBarItem.image = [UIImage imageNamed:image];
    childViewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    childViewController.tabBarItem.title = title;
    
    [childViewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : BYRGBColor(0, 122, 255)} forState:UIControlStateSelected];

    childViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    [self addChildViewController:childViewController];
}
-(void)dealloc
{
    
}

@end
