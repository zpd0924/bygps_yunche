//
//  AppDelegate.m
//  BYGPS
//
//  Created by miwer on 16/7/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "AppDelegate.h"
#import "BYTabBarController.h"
#import "BYDetailTabBarController.h"
#import "BYHomeViewController.h"
#import "BYLoginViewController.h"
#import "EBForeNotification.h"
#import "PlaySoundHelper.h"
#import "EasyNavigation.h"
#import "BYAlarmPositionController.h"
#import "BYMyWorkOrderController.h"
#import "BYMyWorkOrderDetailController.h"
#import "BYNetworkHelper.h"
#import "BYLoginHttpTool.h"

#import "BYPushNaviModel.h"
#import "BYWXManagerTool.h"
#import "WXApiManager.h"
#import "BYWechatLoginModel.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UserNotifications/UserNotifications.h>//iOS推送框架
#import <UMMobClick/MobClick.h>
#import <Bugly/Bugly.h>
#import "BYDateFormtterTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "BYRouteModel.h"
#import "BYRouteApisModel.h"
#import "UMSAgent.h"
#import "BYVerUpdateModel.h"
#import "BYAlertTip.h"

static NSString * const weiXinJudgeUrl = @"now/weiXinJudge";

@interface AppDelegate () <UNUserNotificationCenterDelegate,WXApiDelegate,WXApiManagerDelegate,TencentSessionDelegate,QQApiInterfaceDelegate,BMKLocationAuthDelegate>

@property (nonatomic,strong) BYRouteModel *routeModel;///寻址模型
//@property (nonatomic,strong) BYVerUpdateModel *updateModel;
@property (nonatomic,strong) BYVerUpdateModel *updateModel;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self initRootVc];//初始化根控制器
    
    //设置百度SDK appkey
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:baiduMapKey authDelegate:self];
    if (![[[BMKMapManager alloc]init] start:baiduMapKey generalDelegate:nil]) {
        BYLog(@"manager start failed!");
    }
    //设置高德sdk appkey
    [AMapServices sharedServices].apiKey = AMAPKey;
    
    [self registerNotificationSetting];//推送相关操作
    
    [self setUmengConfig];//设置友盟统计
    
    
    //向微信注册
    [WXApi registerApp:@"wxda5e1bbd81dad292"];
    
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用
    
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    manager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //崩溃统计
    [Bugly startWithAppId:@"7151b76365"];
    
    [[TencentOAuth alloc] initWithAppId:@"1107751249" andDelegate:self];
    
    [self loadRoute];
    
    
    
    return YES;
}

///寻址
- (void)loadRoute{
    BYWeakSelf;
    [[BYNetworkHelper sharedInstance] POSTRouteUrlWithSuccess:^(id data) {
        BYLog(@"%@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.routeModel = [BYRouteModel yy_modelWithDictionary:data];
            
            
            NSString *portStr = weakSelf.routeModel.defaults.port;
            if (portStr.length) {
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@:%@/by-app-web/",weakSelf.routeModel.defaults.host,weakSelf.routeModel.defaults.port];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }else{
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@/by-app-web/",weakSelf.routeModel.defaults.host];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }
            for (BYRouteApisModel *model in weakSelf.routeModel.apis) {
                if ([model.apiName isEqualToString:@"command-h5"]) {
                    NSString *baseH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@/%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],@"dist-html"];
                    [BYSaveTool setValue:baseH5Url forKey:BYH5Url];
                    
                }
                if ([model.apiName isEqualToString:@"privacy-h5"]) {
                    
                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    
                    [BYSaveTool setValue:basePravacyH5Url forKey:BYPrivacyH5Url];
                }
                if ([model.apiName isEqualToString:@"umscollector"]){
                    NSString *umscollectorUrl = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    
                    [BYSaveTool setValue:umscollectorUrl forKey:BYUmscollectorUrl];
                    
                }
            }
            [weakSelf initUMSA];
        });
        
        
        
    } failure:^(NSError *error) {
        
    } showError:NO];
}

#pragma mark -- 版本升级
- (void)verUpdate{
    BYWeakSelf;
    [BYLoginHttpTool POSTUpdateWithUserNameSuccess:^(id data) {
        BYLog(@"update = %@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.updateModel = [[BYVerUpdateModel alloc] initWithDictionary:data[@"reply"] error:nil];
            if(!weakSelf.updateModel.flag)
                return;
            if(weakSelf.updateModel.isForce){
                
                
                [BYAlertTip ShowOnlyAlertWith:@"升级提示" message:weakSelf.updateModel.Description viewControl:self.window.rootViewController andSureBack:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.updateModel.fileUrl]];
                }];
                
                
            }else{
                //                if([BYObjectTool isFirstGoInApp]){
                [BYAlertTip ShowAlertWith:@"升级提示" message:weakSelf.updateModel.Description withCancelTitle:@"取消" withSureTitle:@"确定" viewControl:self.window.rootViewController andSureBack:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.updateModel.fileUrl]];
                } andCancelBack:^{
                    
                }];
                //                }
            }
            
        });
    }];
}


#pragma mark -- UMSA初始化
- (void)initUMSA{
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",[BYSaveTool objectForKey:BYUmscollectorUrl],@"?method=/ums"];
    [UMSAgent setOnLineConfig:YES];
    
    [UMSAgent startWithAppKey:@"chedaian" serverURL:URL];
    [UMSAgent setIsLogEnabled:YES];
    [UMSAgent postTag:@"标越车贷安"];
    
}

-(void)setUmengConfig{
    
    UMConfigInstance.appKey = BYUMengKey;
    UMConfigInstance.channelId = @"www.vvsmart.com";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
//    [MobClick setScenarioType:E_UM_GAME|E_UM_DPLUS];
//    [MobClick ]
}

-(void)registerNotificationSetting{
    
    if (IOS10) {//iOS10推送注册
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                BYLog(@"request authorization succeeded!");
            }
        }];
        center.delegate = self;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            BYLog(@"%@",settings);
        }];
    }else{
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //初始化前台推送时点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
}
//微信重写两个方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.scheme isEqualToString:@"wxda5e1bbd81dad292"]) {
         return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host containsString:@"qq"]){
         return [QQApiInterface handleOpenURL:url delegate:self];
    }else{
         return YES;
    }
    
//    if ([WXApi handleOpenURL:url delegate:self]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }else if([TencentOAuth HandleOpenURL:url]){
//
//        return [QQApiInterface handleOpenURL:url delegate:self];
//    }else{
//        return YES;
//    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"wxda5e1bbd81dad292"]) {
         return [WXApi handleOpenURL:url delegate:self];
    }else if (([url.host containsString:@"qq"]) ){
         return [QQApiInterface handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
//    if ([WXApi handleOpenURL:url delegate:self]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }else{
//        return [QQApiInterface handleOpenURL:url delegate:self];
//    }
}

-(void)onResp:(BaseResp *)resp{
    //Wechat分享返回
//    enum  WXErrCode {
//        WXSuccess           = 0,    /**< 成功    */
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
//    };
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]] && resp.type == ESENDMESSAGETOQQRESPTYPE)
    {
        SendMessageToQQResp* sendReq = (SendMessageToQQResp*)resp;
        // sendReq.result->0分享成功 -4取消分享
        if ([sendReq.result integerValue] == 0) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"result"];
            
           [[NSNotificationCenter defaultCenter] postNotificationName:@"shareToWechatOrQQResponseNotification" object:nil userInfo:dict];
        }else{
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"result"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareToWechatOrQQResponseNotification" object:nil userInfo:dict];
        }
    }
    
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        SendMessageToWXResp * tmpResp = (SendMessageToWXResp *)resp;
        
        if (tmpResp.errCode == WXSuccess) {
            
          
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"result"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareToWechatOrQQResponseNotification" object:nil userInfo:dict];
            
        }else{
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"result"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareToWechatOrQQResponseNotification" object:nil userInfo:dict];
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            
            BYLog(@"微信登陆成功!");
            [self GetWXAccessTokenWithCode:authResp.code];
        }else{
            
            BYLog(@"取消微信登陆!");
            BYShowError(@"取消登陆或登录失败");
        }
    }
}

-(void)GetWXAccessTokenWithCode:(NSString *)code{
    [[BYWXManagerTool sharedInstance] GetWXAccessTokenWithCode:code success:^(id data) {
        BYLog(@"%@",data);
        BYWechatLoginModel *wechatModel = [BYWechatLoginModel yy_modelWithDictionary:data];
        if (!wechatModel.openid.length && !wechatModel.access_token.length) {
            BYShowError(@"登录失败");
            return ;
        }
        [BYSaveTool setValue:wechatModel.openid forKey:BYWeixinOpenId];
        [BYSaveTool setValue:wechatModel.access_token forKey:BYWXAccessToken];
        
        NSDictionary *opidDict = [NSDictionary dictionaryWithObject:wechatModel.openid
                                                      forKey:@"openid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendAuthRespResponseNotification" object:nil userInfo:opidDict];
       
    } failure:^(NSError *error) {
        
    } showHUD:YES showError:YES];

}
//#ifdef Ios10
#ifdef IOS10
//iOS10前台收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    completionHandler(UNNotificationPresentationOptionAlert |UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);

    BYLogFunc;
    
    if ([self currentVcIsHomeVc]) {//收到推送时向首页发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNotificationKey object:nil];
    }

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        PlaySoundHelper * helper = [[PlaySoundHelper alloc] initForPlayingVibrate];
        [helper play];//震动跟随系统
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    completionHandler();
    BYLogFunc; // 系统要求执行这个方法
    //如果进来时登录页面的话就直接返回
    if ([[self topVcWithRootVc:self.window.rootViewController] isKindOfClass:[BYLoginViewController class]]) return;
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self pushToAlarmPositionWith:userInfo];
        
        [self setDesktopUnreadCount];//处理角标
    }
}
#endif
//#else
#ifdef IOS9
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    BYLogFunc;
    // UIBackgroundFetchResultNewData,  成功接收到数据
    // UIBackgroundFetchResultNoData,   没有接收到数据
    // UIBackgroundFetchResultFailed    接受失败
    if (userInfo) {//在此方法中一定要调用completionHandler这个回调，告诉系统是否处理成功
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
    //如果进来时登录页面的话就直接返回
    if ([[self topVcWithRootVc:self.window.rootViewController] isKindOfClass:[BYLoginViewController class]]) return;

    if (application.applicationState == UIApplicationStateInactive) {
        BYLog(@"UIApplicationStateInactive : %@",userInfo);
        
        [self pushToAlarmPositionWith:userInfo];

        [self setDesktopUnreadCount];//处理角标
        
    }else if (application.applicationState == UIApplicationStateActive){
        BYLog(@"UIApplicationStateActive : %@",userInfo);
        PlaySoundHelper * helper = [[PlaySoundHelper alloc] initForPlayingVibrate];
        [helper play];//震动跟随系统
        //系统声音弹窗
        BOOL isIos10 = BYIOS_VERSION >= 10 ? YES : NO;
        [EBForeNotification handleRemoteNotification:userInfo soundID:NULL isIos10:isIos10];//1312
        
        if ([self currentVcIsHomeVc]) {//收到推送时向首页发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:BYNotificationKey object:nil];
        }
    }
}
#endif

-(void)setDesktopUnreadCount{//处理badge
    
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
}

-(void)eBBannerViewDidClick:(NSNotification *)notification{//前台跳转
    
    [self pushToAlarmPositionWith:notification.object];
}
-(void)pushToAlarmPositionWith:(NSDictionary *)userInfo{//inactive跳转
    
    BYLog(@"userInfo = %@",userInfo);
    //    通过获取当前控制器,再获取该导航栏,进行push
    if (![[self topVcWithRootVc:self.window.rootViewController] isKindOfClass:[BYLoginViewController class]]) {
//        发送了
//        1:报警推送,2:现堪推送,5:微信拆机订单,7-20:微信模板推送,30-45:报警恢复推送 9803：审核推送 9804：超时工单推送
        
        if ([userInfo[@"aps"][@"messageType"] integerValue] == 1){
            BYAlarmPositionController * alarmPosiVc = [[BYAlarmPositionController alloc] init];
            alarmPosiVc.isRemoteNotification = YES;
            alarmPosiVc.alarmId = userInfo[@"aps"][@"id"];
            
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:alarmPosiVc animated:YES];
        }
        if ([userInfo[@"aps"][@"messageType"] integerValue] >= 30 && [userInfo[@"aps"][@"messageType"] integerValue] <= 45){
            BYAlarmPositionController * alarmPosiVc = [[BYAlarmPositionController alloc] init];
            alarmPosiVc.isRemoteNotification = YES;
            alarmPosiVc.alarmId = userInfo[@"aps"][@"id"];
            
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:alarmPosiVc animated:YES];
        }
        if ([userInfo[@"aps"][@"messageType"] integerValue] == 9803){
            BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
            vc.row = 1;
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:vc animated:YES];

        }
        if ([userInfo[@"aps"][@"messageType"] integerValue] == 9804){
            BYMyWorkOrderController *vc = [[BYMyWorkOrderController alloc] init];
            vc.row = 0;
            vc.isOverTime = YES;
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:vc animated:YES];
        }
        if ([userInfo[@"aps"][@"messageType"] integerValue] == 9805){
            
            BYMyWorkOrderDetailController *vc = [[BYMyWorkOrderDetailController alloc] init];
            vc.orderNo = userInfo[@"aps"][@"id"];
            NSString *serviceType = userInfo[@"aps"][@"serviceType"];
            switch ([serviceType integerValue]) {
                case 1://安装
                    vc.sendOrderType = BYWorkSendOrderType;
                    break;
                case 2://检修
                    vc.sendOrderType = BYRepairSendOrderType;
                    break;
                case 3://拆机
                    vc.sendOrderType = BYUnpackSendOrderType;
                    break;
                default:
                    break;
            }
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:vc animated:YES];
        }
        if ([userInfo[@"aps"][@"messageType"] integerValue] == 4){
            
//            {"aps": {"badge": 1,"messageType": "${(sendType) !''}", "msg": "${(title)!''}","model": "${(model)!''}","deviceId": "${(deviceId)!''}"}
            BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
            BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
            pushModel.deviceId = [userInfo[@"aps"][@"deviceId"] integerValue];
            pushModel.isMark = @"1";
//            pushModel.model = userInfo[@"aps"][@"model"];
            
            detailTabBarVC.selectedIndex = 2;
            detailTabBarVC.model = pushModel;
            [[self topVcWithRootVc:self.window.rootViewController].navigationController pushViewController:detailTabBarVC animated:YES];
        }
    }
}

//寻找当前展示的控制器, 用于
- (UIViewController*)topVcWithRootVc:(UIViewController *)rootVc{

    if ([rootVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarController = (UITabBarController *)rootVc;
        return [self topVcWithRootVc:tabBarController.selectedViewController];
    } else if ([rootVc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * navigationController = (UINavigationController *)rootVc;
        return [self topVcWithRootVc:navigationController.visibleViewController];
    } else if (rootVc.presentedViewController) {
        UIViewController * presentedViewController = rootVc.presentedViewController;
        return [self topVcWithRootVc:presentedViewController];
    } else {
        return rootVc;
    }
}

-(BOOL)currentVcIsHomeVc{
    
    if ([[self topVcWithRootVc:self.window.rootViewController] isKindOfClass:[BYHomeViewController class]]) {
        
        BYHomeViewController * wrapVc = (BYHomeViewController *)[self topVcWithRootVc:self.window.rootViewController];
        return [wrapVc isKindOfClass:NSClassFromString(@"BYHomeViewController")];
    }
    
    return NO;
}

/** 接收服务器传回的设备唯一标识 token */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // 第一次运行获取到DeviceToken时间会比较长！
    // 将deviceToken转换成字符串，以便后续使用
    NSString *token = [deviceToken description];
    
    [BYSaveTool setValue:token forKey:BYDeviceToken];
    
    BYLog(@"deviceTokenData : %@", token);

}

/** 注册推送服务失败 */
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    BYLog(@"推送注册失败 : %@",error);
}

-(void)initRootVc{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        BYLog(@"微信已安装");
        [BYSaveTool setBool:YES forKey:BYWXIsStall];
    }else
    {
        [BYSaveTool setBool:NO forKey:BYWXIsStall];
        BYLog(@"微信未安装");
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
   
    if ([BYSaveTool valueForKey:BYToken] != nil) {
        //判断登录是否大于七天
            if ([BYSaveTool isContainsKey:BYLoginDateTime]){
                double nowDateTimeInterv = [BYDateFormtterTool getNowTimestamp];
                
                double loginDateTime = [[BYSaveTool objectForKey:BYLoginDateTime] doubleValue];
                
                double overDueTime = nowDateTimeInterv - loginDateTime;
                if (overDueTime > 7*24*3600){
                    BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                    EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                    self.window.rootViewController = navi;
                    [self.window makeKeyAndVisible];
                }else{
//                    BYTabBarController *tabbarVC = [[BYTabBarController alloc] init];
//                    EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:tabbarVC];
//                    self.window.rootViewController = tabbarVC;
//                    [self.window makeKeyAndVisible];
                    BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                    loginVC.isAutoLogin = YES;
                    EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                    self.window.rootViewController = navi;
                    [self.window makeKeyAndVisible];
                }
            }else{
                BYLog(@"%@",[BYSaveTool valueForKey:BYusername]);
                BYLog(@"%@",[BYSaveTool valueForKey:BYpassword]);
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
               
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                self.window.rootViewController = navi;
                [self.window makeKeyAndVisible];
            }
    }else{
        BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
        EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navi;
        [self.window makeKeyAndVisible];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    BYLogFunc;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BYLogFunc;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    BYLogFunc;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BYNetworkHelper startMonitoring];//监听网络状况
    if ([self currentVcIsHomeVc]) {//程序进入前台,且当前页面是首页时发送的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BYBecomeActiveKey object:nil];
    }
    
    [self verUpdate];
    
    BYLogFunc;
    
    NSString *username = [BYSaveTool objectForKey:BYusername];
    NSString *password = [BYSaveTool objectForKey:BYpassword];
    if (username.length && password.length) {
        [BYLoginHttpTool PostLogin:username password:password sourceFlag:1 Success:^(id data) {
            [BYSaveTool setBool:YES forKey:BYLoginState];
            
        } showError:NO];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EBBannerViewDidClick object:nil];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        BYLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*
 
 //通过获取当前控制器来present
 //    if (![[self topVcWithRootVc:self.window.rootViewController] isKindOfClass:[BYLoginViewController class]]) {
 //
 //        BYAlarmPositionController * alarmPosiVc = [[BYAlarmPositionController alloc] init];
 //        alarmPosiVc.isRemoteNotification = YES;
 //        alarmPosiVc.alarmId = userInfo[@"aps"][@"AlarmId"];
 //        BYNavigationController * navi = [[BYNavigationController alloc] initWithRootViewController:alarmPosiVc];
 //
 //        //present到报警地图页面
 //        [[self topVcWithRootVc:self.window.rootViewController] presentViewController:navi animated:YES completion:nil];
 //    }
 
 */

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSString *host = webpageURL.host;
        if ([host isEqualToString:@"www.vbgps.com"]) {
            //判断域名是自己的网站，进行我们需要的处理
            BYLog(@"https://www.vbgps.com");
        }else{
            [[UIApplication sharedApplication]openURL:webpageURL];
        }
    }
    return YES;
}



@end
