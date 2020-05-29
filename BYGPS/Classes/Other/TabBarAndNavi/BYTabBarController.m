//
//  BYTabBarController.m
//  BYGPS
//
//  Created by miwer on 16/7/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYTabBarController.h"
#import "EasyNavigation.h"
#import "BYHomeViewController.h"
#import "BYControlViewController.h"
#import "BYMeTableController.h"
#import "YCHomeVC.h"

@interface BYTabBarController () <UITabBarControllerDelegate>

//@property(nonatomic,strong)UIView * selectBgView;

@end

@implementation BYTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self addAllViewControllers];
    self.delegate = self;
    
}

-(void)addAllViewControllers{
    
    [self addViewController:[[BYHomeViewController alloc] init] image:@"tab_icon_home_normal" selectedImage:@"tab_icon_home_on" title:@"首页"];
   
    
    [self addViewController:[[BYControlViewController alloc] init] image:@"tab_icon_control_normal" selectedImage:@"tab_icon_control_on" title:@"监控"];
    
    
    [self addViewController:[[BYMeTableController alloc] init] image:@"tab_icon_user_normal" selectedImage:@"tab_icon_user_on" title:@"我的"];
}

#pragma mark - <UITabBarDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (tabBarController.selectedIndex) {
        case 0:
            MobClickEvent(@"botton_home", @"");
            break;
        case 1:
            MobClickEvent(@"botton_monitoring", @"");
            break;
        default:
            MobClickEvent(@"botton_me", @"");
            break;
    }
    
}

#pragma mark - 设置tabBarItems的文字属性
+(void)load
{
    // 1.正常状态下的文字
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = BYGlobalTextGrayColor;
    normalAttr[NSFontAttributeName] = BYS_T_F(10);
    
//    // 2.选中状态下的文字
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = UIColorHexFromRGB(0x0D7DE0);
    selectedAttr[NSFontAttributeName] = BYS_T_F(10);
    
    // 3.统一设置UITabBarItem的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
}

#pragma mark - 添加一个子控制器的方法
- (void)addViewController:(UIViewController *)childViewController image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
        EasyNavigationController *nav = [[EasyNavigationController alloc] initWithRootViewController:childViewController];
        nav.tabBarItem.image = [UIImage imageNamed:image];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
        nav.tabBarItem.title = title;
        nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        
        // 2.选中状态下的文字
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorHexFromRGB(0x0D7DE0)} forState:UIControlStateSelected];
        
        [self addChildViewController:nav];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
