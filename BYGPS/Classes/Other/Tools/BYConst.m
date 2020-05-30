//
//  BYConst.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYConst.h"

@implementation BYConst

CGFloat const BYNavBarMaxH = 64;

CGFloat const BYNavBarMinH = 64;

CGFloat const BYTabBarH = 49;

CGFloat const BYStatusBarH = 0;

CGFloat const BYTextFieldPullUpHeight = 70;

CGFloat const BYTabNaviHidenDuration = 0.25;

CGFloat const BYTimeoutInterval =15.0;

NSString *const baseImageUrl = @"baseImageUrl";

NSString * const remeberPassword = @"remeberPassword";

NSString * const remeberAutoLogin = @"remeberAutoLogin";

NSString * const BYusername = @"BYusername";
NSString * const BYOssDomainUrl = @"ossDomainUrl";

NSString * const BYpassword = @"BYpassword";

NSString * const nickName = @"nickName";

NSString * const BYUid = @"BYUid";

//NSString * const loginName = @"loginName";

NSString * const mobile = @"mobile";

NSString * const installAuthorityKey = @"installAuthorityKey";

NSString * const demolitionAuthorityKey = @"demolitionAuthorityKey";

NSString * const weixinUserIdKey = @"weixinUserIdKey";

NSString * const heartbeatKey = @"heartbeatKey";
//设置预约拆机权限
NSString * const BYConventionRemoveKey = @"BYConventionRemoveKey";

NSString * const BYAlarmInfoKey = @"BYAlarmInfoKey";

NSString * const BYIsReadinessKey = @"BYIsReadinessKey";

NSString * const BYIsValid = @"BYIsValid";//设置是否绑定手机号验证

NSString * const BYNowTake = @"BYNowTake";//设置现拍权限

NSString * const BYMonitorInfo = @"BYMonitorInfo";//查看高危区域权限

//NSString * const BYControlIsOpenMonitor = @"BYControlIsOpenMonitor";//监控页面是否打开高危

//NSString * const BYTrackIsOpenMonitor = @"BYTrackIsOpenMonitor";//监控页面是否打开高危

//NSString * const BYAlarmIsOpenMonitor = @"BYAlarmIsOpenMonitor";//报警详情页是否打开高危

NSString *const examineYes = @"examineYes";

NSString * const groupName = @"groupName";
NSString * const groupId = @"groupId";

NSString * const BYToken = @"BYToken";

NSString * const BYIsRiskManager = @"BYIsRiskManager";
NSString * const BYType = @"BYType";

NSString * const BYWeixinOpenId = @"BYWeixinOpenId";

NSString * const BYInstallCityKey = @"BYInstallCityKey";

NSString * const BYDeviceToken = @"BYDeviceToken";

NSString * const BYTrackRefreshDuration = @"BYTrackRefreshDuration";

NSString * const BYControlRefreshDuration = @"BYControlRefreshDuration";

NSString * const BYNotificationKey = @"BYNotificationKey";

NSString * const BYBecomeActiveKey = @"BYBecomeActiveKey";

NSString * const BYRepeatLoginKey = @"BYRepeatLoginKey";

NSString * const BYNetStatusNotificationKey = @"BYNetStatusNotificationKey";

NSString * const BYDemolishInstallSuccessNotifiKey = @"BYDemolishInstallSuccessNotifiKey";

NSString * const BYAccomplishTaskSuccessNotifiKey = @"BYAccomplishTaskSuccessNotifiKey";

NSString * const mapFullScreen = @"mapFullScreen";

//新增权限 
NSString * const BYCarNumberInfo = @"BYCarNumberInfo";//查看车牌号权限

NSString * const BYCarOwnerInfo  = @"BYCarOwnerInfo";//查看车主姓名权限

NSString * const BYMySendOrderKey = @"BYMySendOrderKey";         //装机派权限
NSString * const BYAutoInstallOrder = @"BYAutoInstallOrder";       //自助装权限
NSString * const BYEditCarKey = @"BYEditCarKey";


NSString * const BYGPSUseBaiduMap = @"BYGPSUseBaiduMap";

///扫描key
NSString * const AUTHCODE = @"413F947C035EC13D1924";

///图片路径
NSString * const BYImgeBucket = @"bucket";

///手动切换环境标志
NSString * const BYHandSetRouteUrl = @"BYHandSetRouteUrl";

/// MARK: 测试/发布环境标志, 0=develop, 1=product  上架注意更改新的ver = BYAppCode值
#define ISNETWORKWAN 1

//appkey。云车  yunchedaian    车贷安 chedaian
#if ISNETWORKWAN
NSString * const BYNewRouteUrl = @"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=100&method=by.router.api.server&env=release";
//NSString * const BYNewRouteUrl = @"http://router.appleframework.com/router?format=json&appkey=chedaian&v=1.0&ver=290&method=by.router.api.server&env=release";
NSString * const BYBaseUrl = @"baseUrl";
NSString * const BYH5Url = @"h5Url";
NSString * const BYPrivacyH5Url = @"BYPrivacyH5Url";
NSString * const BYUmscollectorUrl = @"BYUmscollectorUrl";
NSString * const BYAppCode = @"100";
#else
NSString * const BYBaseUrl = @"baseUrl";
NSString * const BYNewRouteUrl = @"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=100&method=by.router.api.server&env=test";
//NSString * const BYNewRouteUrl = @"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=2.0&ver=290&method=by.router.api.server&env=dev";
NSString * const BYH5Url = @"h5Url";
NSString * const BYPrivacyH5Url = @"BYPrivacyH5Url";
NSString * const BYUmscollectorUrl = @"BYUmscollectorUrl";
NSString * const BYAppCode = @"100";
#endif


NSString * const webSocketUrl = @"webSocketUrl";


NSString * const OCRKey = @"8NiugkXZfZzRxfue2rin3Z";
NSString * const OCRSecret = @"7393817443434d0ca498c22b11d45006";

NSString * const baiduMapKey = @"B8LMhmprFFb6pOBvAV0EFTsxAcMmyUsB";

NSString * const AMAPKey = @"05d70393bcfe714d83d560257e9ac492";//高德地图key

//NSString * const BYUMengKey = @"5806068967e58ee554000037";
NSString * const BYUMengKey = @"5bbab785b465f5145c00003c";

NSString * const BYWXBaseUrl = @"https://api.weixin.qq.com/sns/oauth2/access_token";

NSString * const BYWXAppId = @"wxda5e1bbd81dad292";

NSString * const BYWXAppSecret = @"7287efbac77c2fa49ac817b7da32476b";

NSString * const loginForRootVc = @"loginForRootVc";

NSString * const BYWXScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";

NSString * const BYWXState = @"xxx";

NSString * const BYWXAccessToken = @"BYWXAccessToken";

NSString * const BYWXRefreshToken = @"BYWXRefreshToken";

NSString * const BYWXOpenUserData = @"BYWXOpenUserData";

NSString * const BYWXIsStall = @"BYWXIsStall";

//2.7
NSString * const BYDevicesKey = @"BYDevicesKey";
NSString * const BYAlarmsProcessKey = @"BYAlarmsProcessKey";
NSString * const BYNowTaskKey = @"BYNowTaskKey";
NSString * const BYNowCheckKey = @"BYNowCheckKey";
NSString * const BYNowCheckCreatKey = @"BYNowCheckCreatKey";
NSString * const BYMonitorKey = @"BYMonitorKey";
NSString * const BYDeviceConfigSetKey = @"BYDeviceConfigSetKey";
NSString * const BYDeviceConfigCommandKey = @"BYDeviceConfigCommandKey";
NSString * const BYDeviceConfigRestartKey = @"BYDeviceConfigRestartKey";
NSString * const BYMonitorTrackKey = @"BYMonitorTrackKey";
NSString * const BYMonitorStayPointKey = @"BYMonitorStayPointKey";
NSString * const BYReportKey = @"BYReportKey";
NSString * const BYDeviceConfigKey = @"BYDeviceConfigKey";
NSString * const BYBreakingOilElectricity = @"BYBreakingOilElectricity";
NSString * const BYDeviceConfigIntervalKey = @"BYDeviceConfigIntervalKey";

NSString * const BYCarShareKey = @"app:car:car_share";

NSString * const BYLocationCityKey = @"BYLocationCityKey";
NSString * const BYCurrentCityKey = @"BYCurrentCityKey";
///OSS
NSString * const BYAccessId = @"bucket";
NSString * const BYbucket = @"bucket";
NSString * const BYEndpoint = @"endpoint";
NSString * const BYSignature = @"signature";

NSString * const BYLoginState = @"BYLoginState";//登录状态
NSString * const BYLoginDateTime = @"BYLoginDateTime";

NSString * const BYNeedToAudit = @"BYNeedToAudit";
NSString * const BYVisitorGroup = @"visitorGroup";//是否为散户false ture

NSString * const sameAdd = @"sameAdd";

@end
