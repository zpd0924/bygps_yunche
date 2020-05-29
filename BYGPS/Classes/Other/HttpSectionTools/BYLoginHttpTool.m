
//
//  BYLoginHttpTool.m
//  BYGPS
//
//  Created by miwer on 16/8/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYLoginHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYUploadCurrentVersion.h"


static NSString * const loginUrl = @"user/login";
static NSString * const logoutUrl = @"user/logout";
static NSString * const updatePasswordUrl = @"user/editpwd";
static NSString * const messageCodeUrl = @"user/sendCode";
static NSString * const bindMobileUrl = @"user/bindMobile";
static NSString * const bindWeiXinUrl = @"user/bindWeixin";
static NSString * const unBindMobileUrl = @"user/unbindMobile";

static NSString * const updateUrlMethod = @"/ums/appupdate";//版本更新接口
static NSString * const updateUrl = @"router";//版本更新接口

@implementation BYLoginHttpTool

//登录2.6.5
+(void)PostLogin:(NSString *)username password:(NSString *)password sourceFlag:(NSInteger)sourceFlag Success:(void (^)(id))success showError:(BOOL)showError
{
    
    if (sourceFlag == 1 &&( username.length == 0 || password.length == 0)) {
        [BYProgressHUD by_showErrorWithStatus:@"请输入账号或密码"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = username;
    params[@"password"] = password;
    params[@"flag"] = @"2";
    params[@"sourceFlag"] = @(sourceFlag);
    //微信OpenID
    params[@"weixin"] = [BYSaveTool valueForKey:BYWeixinOpenId];
//    params[@"version"] = app_Version;
    params[@"loginPackage"] = BYloginPackage;
//
    if (BYSIMULATOR) {
        params[@"appToken"] = @"";
    }else{
        NSString * toKenStr = [BYSaveTool valueForKey:BYDeviceToken];
        toKenStr = [toKenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        toKenStr = [toKenStr substringFromIndex:1];
        params[@"appToken"] = [toKenStr substringToIndex:toKenStr.length - 1];
    }
//    NSString * toKenStr = [BYSaveTool valueForKey:BYDeviceToken]; 
//    toKenStr = [toKenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    toKenStr = [toKenStr substringFromIndex:1];
//    params[@"appToken"] = [toKenStr substringToIndex:toKenStr.length - 1];

    [[BYNetworkHelper sharedInstance] POST:loginUrl params:params success:^(id data) {
        
        [BYProgressHUD by_dismiss];
        [BYSaveTool setValue:data[@"needToAudit"] forKey:BYNeedToAudit];
        [BYSaveTool setValue:data[@"token"] forKey:BYToken];//登录成功获取token
        [BYSaveTool setValue:data[@"nickName"] forKey:nickName];//用户名
        [BYSaveTool setValue:data[@"uid"] forKey:BYUid];
        [BYSaveTool setValue:data[@"loginName"] forKey:BYusername];
        [BYSaveTool setValue:data[@"ossDomainUrl"] forKey:BYOssDomainUrl];
        [BYSaveTool setValue:data[@"bucket"] forKey:BYImgeBucket];
        if (![data[@"mobile"] isKindOfClass:[NSNull class]]) {
            [BYSaveTool setValue:data[@"mobile"] forKey:mobile];
        }
        [BYSaveTool setValue:data[@"groupName"] forKey:groupName];
         [BYSaveTool setValue:data[@"groupId"] forKey:groupId];
        
        [BYSaveTool setValue:data[@"baseImageUrl"] forKey:baseImageUrl];
        [BYSaveTool setValue:data[@"isRiskManager"] forKey:BYIsRiskManager];
        if (![data[@"sameAdd"] isKindOfClass:[NSNull class]]) {
            [BYSaveTool setBool:[data[@"sameAdd"] boolValue] forKey:sameAdd];
//            [BYSaveTool setBool:YES forKey:sameAdd];
        }else{
            [BYSaveTool setBool:NO forKey:sameAdd];
        }
        
        
        
        NSDictionary *infoDict = data[@"premission"];
//        2.7权限
        [BYSaveTool setBool:[data[@"visitorGroup"] boolValue] forKey:BYVisitorGroup];
        [BYSaveTool setBool:[infoDict[@"app:devices"] boolValue] forKey:BYDevicesKey];
        [BYSaveTool setBool:[infoDict[@"app:weixin"] boolValue] forKey:BYConventionRemoveKey];
        [BYSaveTool setBool:[infoDict[@"app:alarms"] boolValue] forKey:BYAlarmInfoKey];
        [BYSaveTool setBool:[infoDict[@"app:alarms:process"] boolValue] forKey:BYAlarmsProcessKey];
        [BYSaveTool setBool:[infoDict[@"app:now:task"] boolValue] forKey:BYNowTaskKey];
        [BYSaveTool setBool:[infoDict[@"app:now:check"] boolValue] forKey:BYNowCheckKey];
        [BYSaveTool setBool:[infoDict[@"app:now:check:create"] boolValue] forKey:BYNowCheckCreatKey];
        [BYSaveTool setBool:[infoDict[@"app:monitor"] boolValue] forKey:BYMonitorKey];
//        [BYSaveTool setBool:false forKey:BYMonitorKey];
        [BYSaveTool setBool:[infoDict[@"app:report"] boolValue] forKey:BYReportKey];
        [BYSaveTool setBool:[infoDict[@"app:device:config"] boolValue] forKey:BYDeviceConfigKey];
        [BYSaveTool setBool:[infoDict[@"app:car:car_share"] boolValue] forKey:BYCarShareKey];
        [BYSaveTool setBool:[infoDict[@"app:device:config:set"] boolValue] forKey:BYDeviceConfigSetKey];
        [BYSaveTool setBool:[infoDict[@"app:device:config:command"] boolValue] forKey:BYDeviceConfigCommandKey];
        [BYSaveTool setBool:[infoDict[@"app:device:config:restart"] boolValue] forKey:BYDeviceConfigRestartKey];
        [BYSaveTool setBool:[infoDict[@"app:monitor:track"] boolValue] forKey:BYMonitorTrackKey];
//        [BYSaveTool setBool:false forKey:BYMonitorTrackKey];
        [BYSaveTool setBool:[infoDict[@"app:monitor:stayPoint"] boolValue] forKey:BYMonitorStayPointKey];
        [BYSaveTool setBool:[infoDict[@"app:device:config:breakingOilElectricity"] boolValue] forKey:BYBreakingOilElectricity];
        [BYSaveTool setBool:[infoDict[@"app:device:config:interval"] boolValue] forKey:BYDeviceConfigIntervalKey];
        if ([infoDict[@"app:car:editCar"] isKindOfClass:[NSNull class]]) {
            [BYSaveTool setBool:NO forKey:BYEditCarKey];
        }else{
            [BYSaveTool setBool:[infoDict[@"app:car:editCar"] boolValue] forKey:BYEditCarKey];
        }
        
        
        [BYSaveTool setBool:[infoDict[@"app:device:install"] boolValue] forKey:installAuthorityKey];
        [BYSaveTool setBool:[infoDict[@"app:device:demolition"] boolValue] forKey:demolitionAuthorityKey];
        
        [BYSaveTool setBool:[data[@"heartbeat"] boolValue] forKey:heartbeatKey];
        [BYSaveTool setBool:[infoDict[@"app:monitor:zone"] boolValue] forKey:BYMonitorInfo];//高危区域权限
        
        [BYSaveTool setValue:data[@"weixinUserId"] forKey:weixinUserIdKey];
        
        [BYSaveTool setBool:[data[@"isSpare"] boolValue] forKey:BYIsReadinessKey];
        [BYSaveTool setBool:[data[@"isValid"] boolValue] forKey:BYIsValid];
        //设置查看车主姓名、车牌号权限
        [BYSaveTool setBool:[infoDict[@"app:car:carNum"] boolValue] forKey:BYCarNumberInfo];
        [BYSaveTool setBool:[infoDict[@"app:car:carOwn"] boolValue] forKey:BYCarOwnerInfo];
        
        [BYSaveTool setBool:[infoDict[@"app:mySendOrders"] boolValue] forKey:BYMySendOrderKey];
        [BYSaveTool setBool:[infoDict[@"app:new:auto_order"] boolValue] forKey:BYAutoInstallOrder];
        
        [BYSaveTool setValue:data[@"needToAudit"] forKey:BYNeedToAudit];

        BYLog(@"loginData : %@",data);
        
        if (success) {
            success(data);
        }
        
    } failure:nil showError:showError];
}

//绑定手机号
+(void)PostBindMobileWithMobile:(NSString *)mobile code:(NSString *)code Success:(void (^)(id))success
{
    if (code.length == 0 || mobile.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"请输入手机号或验证码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = mobile;
    params[@"code"] = code;
    
    [[BYNetworkHelper sharedInstance] POST:bindMobileUrl params:params success:^(id data) {
        
        [BYProgressHUD by_dismiss];
        
//        [BYSaveTool setValue:data[@"token"] forKey:BYToken];//登录成功获取token
//        [BYSaveTool setValue:data[@"nickName"] forKey:nickName];//用户名
//        [BYSaveTool setValue:data[@"loginName"] forKey:BYusername];
//        [BYSaveTool setValue:data[@"mobile"] forKey:mobile];
        
        //        BYLog(@"token : %@",[BYSaveTool valueForKey:BYToken]);
        BYLog(@"bindMobileData : %@",data);
        
        if (success) {
            success(data);
        }
        
    } failure:nil showError:YES];

}

//绑定微信号
+(void)PostBindWeiXinWithLoginname:(NSString *)loginname weixinOpenId:(NSString *)weixinOpenId password:(NSString *)password Success:(void (^)(id))success
{
    if (loginname.length == 0 || password.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"请输入账号或密码"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = loginname;
    params[@"weixin"] = weixinOpenId;
    params[@"password"] = password;
    
    [[BYNetworkHelper sharedInstance] POST:bindWeiXinUrl params:params success:^(id data) {
        
        [BYProgressHUD by_dismiss];
        
        
        BYLog(@"bindWeiXinData : %@",data);
        
        if (success) {
            success(data);
        }
        
    } failure:nil showError:YES];

}

//注销
+(void)POSTLogoutSuccess:(void (^)(id data))success{
    
    [[BYNetworkHelper sharedInstance] POST:logoutUrl params:nil success:^(id data) {
        
        [BYSaveTool removeObjectForKey:BYToken];
        if (success) {
            success(data);
        }
        
    } failure:nil showError:NO];
    
}

+(void)POSTUpdatePasswordWithOld:(NSString *)old now:(NSString *)now success:(void (^)())success{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"password"] = old;
    params[@"newpassword"] = now;
    
    [[BYNetworkHelper sharedInstance] POST:updatePasswordUrl params:params success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showSuccessWithStatus:@"修改成功"];
        });
        
        if (success) {
            success();
        }
        
    } failure:nil showError:YES];
    
}

//获取短信验证码
+(void)POSTMessageCodeWithMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"mobile"] = mobile;
    params[@"isReset"] = @"false";
    [[BYNetworkHelper sharedInstance] POST:messageCodeUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
}

+(void)POSTUnbindMobileSuccess:(void (^)(id))success
{
    [[BYNetworkHelper sharedInstance] POST:unBindMobileUrl params:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:YES];
}

//版本更新
+(void)POSTUpdateWithUserNameSuccess:(void (^)(id))success{
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(infoDictionary));
//
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    app_Version = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = updateUrlMethod;
    params[@"appkey"] = @"yunchedaian";
    params[@"versionCode"] = @([BYAppCode integerValue]);
    params[@"platform"] = @"ios";
    params[@"channel"] = @"biaoyue";
    params[@"useridentifier"] = @"GYEMTSBEMNNNZDQC";
    params[@"token"] = [BYSaveTool objectForKey:BYToken];
    
    [[BYNetworkHelper sharedInstance] POST:updateUrl params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:nil showError:NO];
    
}

@end
