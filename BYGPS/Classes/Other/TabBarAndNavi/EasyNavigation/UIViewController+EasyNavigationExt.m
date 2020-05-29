//
//  UIViewController+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//


#import "UIViewController+EasyNavigationExt.h"

#import "EasyNavigationController.h"
#import "EasyNavigationUtils.h"
#import <objc/runtime.h>


@implementation UIViewController (EasyNavigationExt)

/*
- (void)viewWillAppear:(BOOL)animated{
  
    BYLog(@"color = %@",self.navigationView.backgroundColor);
    BYLog(@"color1 = %@" ,BYGlobalBlueColor);
    if (self.navigationView.backgroundColor) {
        UIColor *color1 = self.navigationView.backgroundColor;
        UIColor *color2 = BYGlobalBlueColor;
        CGFloat R1, G1, B1;
        CGFloat R2, G2, B2;
        CGColorRef colorRef1 = color1.CGColor;
        CGColorRef colorRef2 = color2.CGColor;
        // Returns the number of color components (including alpha) associated with a Quartz color
        NSInteger numComponents1 = CGColorGetNumberOfComponents(colorRef1);
        NSInteger numComponents2 = CGColorGetNumberOfComponents(colorRef2);
        if (numComponents1 == 4)
        {
            const CGFloat *components = CGColorGetComponents(colorRef1);
            R1 = components[0];
            G1 = components[1];
            B1 = components[2];
        }
        if (numComponents2 == 4) {
            const CGFloat *components = CGColorGetComponents(colorRef2);
            R2 = components[0];
            G2 = components[1];
            B2 = components[2];
        }
        if (R1 == R2 && G1 == G2 && B1 == B2) {
            BYStatusBarLight;
        }else{
            BYStatusBarDefault;
        }
    }
  
}
 */



- (BOOL)disableSlidingBackGesture
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setDisableSlidingBackGesture:(BOOL)disableSlidingBackGesture
{
    objc_setAssociatedObject(self, @selector(disableSlidingBackGesture), @(disableSlidingBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];
}

- (BOOL)customBackGestureEnabel
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setCustomBackGestureEnabel:(BOOL)customBackGestureEnabel
{
    objc_setAssociatedObject(self, @selector(customBackGestureEnabel), @(customBackGestureEnabel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];

}

- (CGFloat)customBackGestureEdge
{
    return [objc_getAssociatedObject(self, _cmd) floatValue] ;
}
- (void)setCustomBackGestureEdge:(CGFloat)customBackGestureEdge
{
    objc_setAssociatedObject(self, @selector(customBackGestureEdge), @(customBackGestureEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (EasyNavigationViewController *)vcEasyNavController
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setVcEasyNavController:(EasyNavigationViewController *)vcEasyNavController
{
    objc_setAssociatedObject(self, @selector(vcEasyNavController), vcEasyNavController, OBJC_ASSOCIATION_ASSIGN);
}


- (EasyNavigationView *)navigationView
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNavigationView:(EasyNavigationView *)navigationView
{
    objc_setAssociatedObject(self, @selector(navigationView), navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)navigationOrginalHeight
{
    CGFloat orginalHeight = STATUSBAR_HEIGHT + kNavNormalHeight ;
    
    if (self.isShowBigTitle) {
        CGFloat additionalHeight = ISHORIZONTALSCREEM ? 0 : kNavBigTitleHeight ;
        return orginalHeight + additionalHeight ;
    }
    
    return orginalHeight ;
}

- (BOOL)isShowBigTitle
{
    if (ISHORIZONTALSCREEM) {//如果屏幕是水平方向，不要大标题
        return NO ;
    }
    
    BOOL shouldShow = NO ;
    switch (self.navbigTitleType) {
        case NavBigTitleTypeIOS11:
            shouldShow = IS_IOS11_OR_LATER ;
            break;
        case NavBigTitleTypePlus:
            shouldShow = ISIPHONE_6P ;
            break ;
        case NavBigTitleTypeIphoneX:
            shouldShow = ISIPHONE_X ;
            break ;
        case NavBigTitleTypeAll :
            shouldShow = YES ;
            break ;
        case NavBigTitleTypePlusOrX:
            shouldShow = ISIPHONE_X || ISIPHONE_6P ;
            break ;
        default:
            break;
    }
    return shouldShow ;
}

- (NavBigTitleType)navbigTitleType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setNavbigTitleType:(NavBigTitleType)navbigTitleType
{
    objc_setAssociatedObject(self, @selector(navbigTitleType), @(navbigTitleType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //设置大标题的时候，通知导航条刷新高度
    if (self.navigationView) {
        [self.navigationView layoutNavSubViews];
    }
}

- (NavTitleAnimationType)navTitleAnimationType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setNavTitleAnimationType:(NavTitleAnimationType)navTitleAnimationType
{
    objc_setAssociatedObject(self, @selector(navTitleAnimationType), @(navTitleAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIStatusBarStyle)statusBarStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue] ;
}
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    if (self.statusBarStyle == statusBarStyle) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarStyle), @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (BOOL)statusBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    if (self.statusBarHidden == statusBarHidden) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)horizontalScreenShowStatusBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}

-(void)setHorizontalScreenShowStatusBar:(BOOL)horizontalScreenShowStatusBar
{
    if (self.horizontalScreenShowStatusBar == horizontalScreenShowStatusBar) {
        return ;
    }
    objc_setAssociatedObject(self, @selector(horizontalScreenShowStatusBar), @(horizontalScreenShowStatusBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealSlidingGestureDelegate
{
    EasyNavigationController *navController = (EasyNavigationController *)self.navigationController ;
    if (nil == navController) {
        return ;
    }
    
    if (self.disableSlidingBackGesture) {
        navController.interactivePopGestureRecognizer.delegate = nil ;
        navController.interactivePopGestureRecognizer.enabled = NO ;
        return ;
    }
    
    navController.interactivePopGestureRecognizer.delegate = navController ;
    navController.interactivePopGestureRecognizer.enabled = YES ;
    
    if (self.customBackGestureEnabel) {
        
        [navController.interactivePopGestureRecognizer.view addGestureRecognizer:navController.customBackGesture];
        
        navController.customBackGesture.delegate = navController.customBackGestureDelegate ;
        
        navController.interactivePopGestureRecognizer.delegate = nil;
        navController.interactivePopGestureRecognizer.enabled  = NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}



@end














