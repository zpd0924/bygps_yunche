//
//  BYProgressHUD.h
//  网络请求封装Demo
//
//  Created by miwer on 16/8/4.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface BYProgressHUD : SVProgressHUD

+(void)by_showImageWithstatus:(NSString *)status;

+(void)by_show;
//包含黑色背景
+(void)by_showBgViewWithStatus:(NSString *)status;

+(void)by_showSuccessWithStatus:(NSString *)status;

+(void)by_showErrorWithStatus:(NSString *)status;

+(void)by_dismiss;

@end
