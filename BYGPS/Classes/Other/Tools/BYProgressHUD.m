//
//  BYProgressHUD.m
//  网络请求封装Demo
//
//  Created by miwer on 16/8/4.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYProgressHUD.h"

@implementation BYProgressHUD

+(void)by_showImageWithstatus:(NSString *)status{
    [BYProgressHUD showImage:[UIImage imageNamed:@"icon-logo"] status:status];
}

+(void)by_dismiss{
    [BYProgressHUD dismiss];
}

+(void)by_showSuccessWithStatus:(NSString *)status{
    
    [BYProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [BYProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
//    [BYProgressHUD setForegroundColor:[UIColor whiteColor]];//设置tinColor
//    [BYProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:hudAlpha]];;//设置背景颜色
    
    //设置消失时间
    [BYProgressHUD setMinimumDismissTimeInterval:3];
    [BYProgressHUD showSuccessWithStatus:status];
}

+(void)by_showErrorWithStatus:(NSString *)status{
    
//    [BYProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
//    [BYProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [BYProgressHUD setForegroundColor:[UIColor whiteColor]];//设置tinColor
    [BYProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];//设置背景颜色

    //设置消失时间
    [BYProgressHUD setMinimumDismissTimeInterval:2];
    [BYProgressHUD showErrorWithStatus:status];
    
}

+(void)by_show{
    
    //修改动画样式flower
    [BYProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    //修改背景窗样式
    [BYProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //修改背景样式
    [BYProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
   
    
//    [BYProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.65]];
    //修改圆圈颜色
//    [BYProgressHUD setForegroundColor:[UIColor whiteColor]];
    //    [BYProgressHUD setBackgroundColor:BYARGBColor(230, 100, 100, 100)];
    
    [BYProgressHUD show];
    
}

+(void)by_showBgViewWithStatus:(NSString *)status{
    
    //修改动画样式flower
    [BYProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    //修改背景窗样式
    [BYProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //修改背景样式
    [BYProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    //修改圆圈颜色
//    [BYProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:hudAlpha]];
    //修改圆圈颜色
//    [BYProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    [BYProgressHUD showWithStatus:status];
    
}

@end





