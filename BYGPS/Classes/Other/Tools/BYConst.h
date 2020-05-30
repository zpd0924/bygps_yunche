//
//  BYConst.h
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYConst : NSObject
/** 导航栏最大的Y值 */
UIKIT_EXTERN CGFloat const BYNavBarMaxH;

/** 导航栏最小的Y值 */
UIKIT_EXTERN CGFloat const BYNavBarMinH;

/** UITabBar的高度 */
UIKIT_EXTERN CGFloat const BYTabBarH;

/** UITabBar的高度 */
UIKIT_EXTERN CGFloat const BYStatusBarH;

/** textField导致键盘遮挡而改变的高度 */
UIKIT_EXTERN CGFloat const BYTextFieldPullUpHeight;

/** TabBar和Navi的隐藏和显示动画时间 */
UIKIT_EXTERN CGFloat const BYTabNaviHidenDuration;

/** 请求超时时长 */
UIKIT_EXTERN CGFloat const BYTimeoutInterval;

/** 登录Url */
UIKIT_EXTERN NSString * const BYLoginUrl;
/** 全局baseUrl */
UIKIT_EXTERN NSString * const BYBaseUrl;
/** 寻址Url */
UIKIT_EXTERN NSString * const BYNewRouteUrl;

/** 全局H5Url */
UIKIT_EXTERN NSString * const BYH5Url;
/** 全局隐私H5Url */
UIKIT_EXTERN NSString * const BYPrivacyH5Url;

/** 升级Url */
UIKIT_EXTERN NSString * const BYUmscollectorUrl;
/** 升级版本code */
UIKIT_EXTERN NSString * const BYAppCode;

/** 全局车300Url */
UIKIT_EXTERN NSString * const BYCarThreeUrl;
/** 扫描接口 */
UIKIT_EXTERN NSString * const BYOCRUrl;


/** webSocketUrl */
UIKIT_EXTERN NSString * const webSocketUrl;



/**
 *  NSUserDefaultKey
 */
UIKIT_EXTERN NSString * const remeberPassword;//是否记住密码

UIKIT_EXTERN NSString * const remeberAutoLogin;//是否自动登录

UIKIT_EXTERN NSString * const BYusername;//用户名

UIKIT_EXTERN NSString * const BYpassword;//密码password

UIKIT_EXTERN NSString * const nickName;//用户昵称
UIKIT_EXTERN NSString * const BYUid;//用户id
UIKIT_EXTERN NSString * const BYOssDomainUrl;//oss url

//UIKIT_EXTERN NSString * const loginName;//登录名

UIKIT_EXTERN NSString * const mobile;//手机号

UIKIT_EXTERN NSString * const groupName;//所属分组
UIKIT_EXTERN NSString * const groupId;//所属分组id

UIKIT_EXTERN NSString * const BYIsRiskManager;//1：技师兼风控经理
UIKIT_EXTERN NSString * const BYType;//1 客户 2技师



UIKIT_EXTERN NSString * const weixinUserIdKey;



UIKIT_EXTERN NSString * const installAuthorityKey;//安装权限key

UIKIT_EXTERN NSString * const demolitionAuthorityKey;//拆除权限

UIKIT_EXTERN NSString * const heartbeatKey;//设置心跳权限2.7no
//设置预约拆机权限
UIKIT_EXTERN NSString * const BYConventionRemoveKey;

UIKIT_EXTERN NSString * const BYAlarmInfoKey;//设置报警查看权限

UIKIT_EXTERN NSString * const BYIsReadinessKey;//设置备装权限

UIKIT_EXTERN NSString * const BYIsValid;//设置是否绑定手机号验证

//UIKIT_EXTERN NSString * const BYNowTake;//设置现拍权限


//2.7新增权限

UIKIT_EXTERN NSString * const BYDevicesKey;
UIKIT_EXTERN NSString * const BYAlarmsProcessKey;
UIKIT_EXTERN NSString * const BYNowTaskKey;
UIKIT_EXTERN NSString * const BYNowCheckKey;
UIKIT_EXTERN NSString * const BYNowCheckCreatKey;
UIKIT_EXTERN NSString * const BYMonitorKey;
UIKIT_EXTERN NSString * const BYDeviceConfigSetKey;
UIKIT_EXTERN NSString * const BYDeviceConfigCommandKey;
UIKIT_EXTERN NSString * const BYDeviceConfigRestartKey;
UIKIT_EXTERN NSString * const BYMonitorTrackKey;
UIKIT_EXTERN NSString * const BYMonitorStayPointKey;
UIKIT_EXTERN NSString * const BYReportKey;
UIKIT_EXTERN NSString * const BYDeviceConfigKey;
UIKIT_EXTERN NSString * const BYBreakingOilElectricity;
UIKIT_EXTERN NSString * const BYDeviceConfigIntervalKey;
UIKIT_EXTERN NSString * const BYMySendOrderKey;         //装机派权限
UIKIT_EXTERN NSString * const BYAutoInstallOrder;       //自助装权限
UIKIT_EXTERN NSString * const BYEditCarKey;             //是否有编辑车辆的权限
/*✅
 设备列表权限          BYDevicesKey
 报警处理权限          BYAlarmsProcessKey
 现拍我的任务权限       BYNowTaskKey
 现拍检查权限          BYNowCheckKey
 创建现拍权限          BYNowCheckCreatKey
 在线监控权限          BYMonitorKey
 配置设备权限          BYDeviceConfigKey
 报警配置权限          BYDeviceConfigSetKey
 指令发送权限          BYDeviceConfigCommandKey
 指令重启权限          BYDeviceConfigRestartKey
 轨迹查询权限          BYMonitorTrackKey
 停车点查询权限        BYMonitorStayPointKey
 统计分析             BYReportKey
 断油电               BYBreakingOilElectricity
 app:device:config:breakingOilElectricity
*/
 
//新增权限
UIKIT_EXTERN NSString * const BYCarNumberInfo;//查看车牌号权限

UIKIT_EXTERN NSString * const BYCarOwnerInfo;//查看车主姓名权限

UIKIT_EXTERN NSString * const BYMonitorInfo;//查看高危区域权限

UIKIT_EXTERN NSString * const BYCarShareKey;//车辆分享权限


UIKIT_EXTERN NSString *const baseImageUrl;//照片基础路径

UIKIT_EXTERN NSString *const examineYes;//已拍照的数量

UIKIT_EXTERN NSString * const BYToken;//请求token

UIKIT_EXTERN NSString * const BYWeixinOpenId;//微信识别码

UIKIT_EXTERN NSString * const BYInstallCityKey;//省份城市车牌

UIKIT_EXTERN NSString * const BYDeviceToken;//推送deviceToken

UIKIT_EXTERN NSString * const BYTrackRefreshDuration;//实时监控间隔

UIKIT_EXTERN NSString * const BYControlRefreshDuration;//设备监控间隔

UIKIT_EXTERN NSString * const BYNotificationKey;//报警推送发通知的key

UIKIT_EXTERN NSString * const BYBecomeActiveKey;//程序进入前台时的通知key

UIKIT_EXTERN NSString * const BYRepeatLoginKey;//当重新登录时,首页数据的重新刷新

UIKIT_EXTERN NSString * const BYNetStatusNotificationKey;//监听网络状态发生变化的通知key

UIKIT_EXTERN NSString * const BYDemolishInstallSuccessNotifiKey;//预约拆机和拆机成功通知key

UIKIT_EXTERN NSString * const BYAccomplishTaskSuccessNotifiKey;//完成现拍任务成功通知key
UIKIT_EXTERN NSString * const BYVisitorGroup;



UIKIT_EXTERN NSString * const OCRKey;
UIKIT_EXTERN NSString * const OCRSecret;
//使用地图是否为百度地图

UIKIT_EXTERN NSString * const BYGPSUseBaiduMap;

/**
 *  SwitchKey
 */
UIKIT_EXTERN NSString * const mapFullScreen;//是否全屏的key

/**
 *  接入SDK appkey
 */
UIKIT_EXTERN NSString * const baiduMapKey;//百度地图appkey

UIKIT_EXTERN NSString * const AMAPKey;//高德地图key

UIKIT_EXTERN NSString * const BYUMengKey;//友盟统计AppKey

//微信相关APPID appsecret
UIKIT_EXTERN NSString * const BYWXAppId;

UIKIT_EXTERN NSString * const BYWXAppSecret;

UIKIT_EXTERN NSString * const BYWXScope;

UIKIT_EXTERN NSString * const BYWXState;

UIKIT_EXTERN NSString * const BYWXAccessToken;

UIKIT_EXTERN NSString * const BYWXRefreshToken;

UIKIT_EXTERN NSString * const BYWXBaseUrl;

//本地存储和微信openID对应的账号

UIKIT_EXTERN NSString * const BYWXOpenUserData;

UIKIT_EXTERN NSString * const BYWXIsStall;


/**
 *  通知的name
 */
UIKIT_EXTERN NSString * const loginForRootVc;//不自动登录时通知rootVc跟改为tabBarVc


UIKIT_EXTERN NSString * const BYLocationCityKey;//定位城市

UIKIT_EXTERN NSString * const BYCurrentCityKey;//当前城市

///图片路径
UIKIT_EXTERN NSString * const BYImgeBucket;
///OSS

UIKIT_EXTERN NSString * const BYAccessId;
UIKIT_EXTERN NSString * const BYbucket;
UIKIT_EXTERN NSString * const BYEndpoint;
UIKIT_EXTERN NSString * const BYSignature;
///扫描key
UIKIT_EXTERN NSString * const AUTHCODE;
UIKIT_EXTERN NSString * const BYLoginState;//登录状态
///登录时间
UIKIT_EXTERN NSString * const BYLoginDateTime;

//needToAudit
UIKIT_EXTERN NSString * const BYNeedToAudit;

///三址一致性权限

UIKIT_EXTERN NSString * const sameAdd;


/** 派单枚举 */

typedef NS_ENUM(NSInteger,BYSendOrderType)

{
    BYWorkSendOrderType = 0,//装机派单
    BYUnpackSendOrderType,//拆机派单
    BYRepairSendOrderType//检修派单
    
};

///手动切换环境标志
UIKIT_EXTERN NSString * const BYHandSetRouteUrl;


/** 结果页面枚举 */

typedef NS_ENUM(NSInteger,BYResultType)

{
    BYEvaluationSucessType = 1,//技师评价成功
    BYEvaluationFailedType,//技师评价失败
    BYSearchNoDataType,//搜索无数据
    BYSendWorkSucessType,//派单成功
    BYSendWorkFailType,//派单失败
    BYCarSendWorkingType,//车辆在派单中
   
    
};

/** 分享选择员工枚举 */
typedef NS_ENUM(NSInteger,BYShareAddType)

{
    BYWithoutType=1,//外部人员
    BYInsideType//内部人员
    
    
};

/** 分享类型枚举 */
typedef NS_ENUM(NSInteger,BYSharePlatformType)

{
    BYWechatType,//微信
    BYQQType,//qq
    BYLinkType,//复制链接
    
    
};

@end












