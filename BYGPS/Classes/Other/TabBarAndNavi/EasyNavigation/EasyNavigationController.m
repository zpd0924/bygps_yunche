//
//  EasyNavigationController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationController.h"

#import "EasyNavigationUtils.h"
#import "EasyNavigationView.h"
#import "UIViewController+EasyNavigationExt.h"
#import "UIView+EasyNavigationExt.h"
#import "EasyNavigationView+LeftButton.h"


@interface EasyNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIPanGestureRecognizer *customBackGesture ;//自定义侧滑返回
@property (nonatomic,strong)EasyCustomBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理


@property (nonatomic,strong)UINavigationBar *tempNavBar ;

@property (nonatomic,weak)id systemGestureTarget ;

@end

@implementation EasyNavigationController

- (void)dealloc
{
    EasyNotificationRemove(UIApplicationWillChangeStatusBarFrameNotification) ;
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = NO ;
    self.navigationBar.hidden = YES ;
    self.delegate = self ;
    
    self.systemGestureTarget = self.interactivePopGestureRecognizer.delegate ;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    EasyNotificationAdd(statusBarChangeNoti:, UIApplicationDidChangeStatusBarFrameNotification) ;
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 移除全屏滑动手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.systemGestureTarget]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.systemGestureTarget];
    }
    
    //重新处理手势
    [viewController dealSlidingGestureDelegate];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , viewController.navigationOrginalHeight)];
        [viewController.view addSubview:viewController.navigationView];
        
        EasyLog(@"EasyNavigation create : %p",viewController.navigationView);
        if (self.viewControllers.count > 0) {
            kWeakSelf(self)
            UIImage *img = [UIImage imageNamed:@"icon_arr_left"] ;
            UIButton *backButton = [viewController.navigationView addLeftButtonWithTitle:@"" image:img clickCallBack:^(UIView *view) {
                [weakself popViewControllerAnimated:YES];
            }];
            viewController.navigationView.backButton = backButton ;
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            EasyNavigationView  *navView = self.topViewController.navigationView ;
            if (navView.width != self.topViewController.view.width) {
                navView.width = self.topViewController.view.width ;
            }
        });
    }
    
   
  
    
     [super pushViewController:viewController animated:animated];
    
}

/** 出栈 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    /*
     拆机成功页面(BYDemolishSuccessController) --> 退回3个页面
     安装成功页面(BYInstallSuccessController) --> 退回5个页面
     其他页面(拆机预约,指令下发) --> 退回2个页面
     */
    NSInteger targetCount = 0;
    if ([NSStringFromClass([viewController class]) isEqualToString:@"BYDemolishSuccessController"] || [NSStringFromClass([viewController class]) isEqualToString:@"BYAutoServiceSuccessViewController"]) {
        targetCount = 3;
    }else if ([NSStringFromClass([viewController class]) isEqualToString:@"BYInstallSuccessController"]){
        targetCount = 5;
    }else if([NSStringFromClass([viewController class]) isEqualToString:@"BYSelectDeviceController"]){
        targetCount = 1;
        
        return [super popToViewController:self.viewControllers[1] animated:animated];
    }else if ([NSStringFromClass([viewController class]) isEqualToString:@"BYInstallSendOrderController"]){
         return [super popToViewController:viewController animated:animated];
    }else if ([NSStringFromClass([viewController class]) isEqualToString:@"BYMyWorkOrderController"]){
        return [super popToViewController:viewController animated:animated];
    }else if ([NSStringFromClass([viewController class]) isEqualToString:@"BYSendShareController"]){
         return [super popToViewController:viewController animated:animated];
    }else if ([NSStringFromClass([viewController class]) isEqualToString:@"BYAddWithoutController"]){
         return [super popToViewController:viewController animated:animated];
    }
    
    else{
        targetCount = 2;
        //        BYNavigationController * by_navigationController = viewController.by_navigationController;
        //        NSInteger index = [by_navigationController.by_viewControllers indexOfObject:viewController];
        return [super popToViewController:self.viewControllers[2] animated:animated];
    }
    
    // 弹出应该找到包裹viewController的那个BYWarpViewController,pop该控制器
    //    BYNavigationController * by_navigationController = viewController.by_navigationController;
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    return [super popToViewController:self.viewControllers[index - targetCount] animated:animated];
    
    // 弹出应该找到包裹viewController的那个JPWarpViewController,pop该控制器
    //    return [self.navigationController popToViewController:viewController.by_warpViewController animated:animated];
}


- (void)statusBarChangeNoti:(NSNotification *)notifycation
{
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    EasyNavigationView  *navView = self.topViewController.navigationView ;
    if (!navView)  return ;
    
    if (navView.width != self.topViewController.view.width) {
        navView.width = self.topViewController.view.width ;
    }
    
    [navView layoutNavSubViews];
    
    UIDevice *device = [UIDevice currentDevice] ;
    
    if (device.orientation == UIDeviceOrientationPortrait || device.orientation == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"竖屏 ====== %f , %f",self.topViewController.view.width ,self.topViewController.navigationView.height);
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横屏====== %f , %f",self.topViewController.view.width ,self.topViewController.navigationView.height);
    }
    else{
        NSLog(@"未知状态====== %zd",device.orientation );
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.statusBarStyle ;
}


#pragma mark - getter

- (UIPanGestureRecognizer *)customBackGesture
{
    if (nil == _customBackGesture) {
        _customBackGesture = [[UIPanGestureRecognizer alloc]init];
        _customBackGesture.maximumNumberOfTouches = 1 ;
    }
    return _customBackGesture ;
}
- (EasyCustomBackGestureDelegate *)customBackGestureDelegate
{
    if (nil == _customBackGestureDelegate) {
        _customBackGestureDelegate = [[EasyCustomBackGestureDelegate alloc]init];
        _customBackGestureDelegate.navController = self ;
        _customBackGestureDelegate.systemGestureTarget = self.systemGestureTarget ;
    }
    return _customBackGestureDelegate ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
