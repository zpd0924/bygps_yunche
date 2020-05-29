//
//  BYRequestHttpTool.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/25.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYRequestHttpTool.h"
#import "BYNetworkHelper.h"

static NSString * const BYSendCode = @"user/sendCode";//获取验证码
static NSString * const BYSendCodeNum = @"user/sendCodeNum";//获取验证码次数
static NSString * const BYRegisterUsers = @"user/registerUsers";//获取验证码次数
static NSString * const BYResetPwd = @"user/resetPwd";//忘记密码
static NSString * const BYEndShare = @"share/endShare";//结束分享
static NSString * const BYUpdateShare = @"share/updateShare";//编辑分享
static NSString * const BYSaveShare = @"share/saveShare";//保存分享
static NSString * const BYShareCarDevice = @"share/shareCarDevice";//分享查询已安装设备接口
static NSString * const BYMyReceiveShareCount = @"share/myReceiveShareCount";// 我收到分享的车辆数量和未读数量
static NSString * const BYMySendShareCount = @"share/mySendShareCount";//  我发出分享的车辆数量和未读数量
static NSString * const BYMyReceiveShareList = @"share/myReceiveShareList"; ///我收到的分享接口
static NSString * const BYMySendShareList = @"share/mySendShareList"; ///我发出的分享接口

static NSString * const BYFindListUserByUserWithGroup = @"user/findListUserByUserWithGroupForApp";///查询集团下所有用户和分组名


static NSString * const BYFindListUserByGroupIdUser = @"user/findListUserByGroupId";///根据groupId查询改分组下所有用户
static NSString * const BYGroupTreesForShare = @"api/common/groupTreesForShare";//分享所属分组列表接口

@implementation BYRequestHttpTool
///发送验证码
+(void)POSTSendCodeParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POSTSendCodeParams:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showHUD:YES showError:YES];
    
}

///验证发送验证码次数
+(void)POSTSendCodeNumberParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYSendCodeNum params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///注册
+(void)POSTRegisterUsersParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYRegisterUsers params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///忘记密码

+(void)POSTResetPwdParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYResetPwd params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}

///结束分享
+(void)POSTEndShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYEndShare params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///编辑分享
+(void)POSTUpdateShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYUpdateShare params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///保存分享
+(void)POSTSaveShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYSaveShare params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///分享查询已安装设备接口
+(void)POSTShareCarDeviceParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYShareCarDevice params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///我收到分享的车辆数量和未读数量
+(void)POSTMyReceiveShareCountParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYMyReceiveShareCount params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///我发出分享的车辆数量和未读数量
+(void)POSTMySendShareCountParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYMySendShareCount params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}

///我收到的分享接口
+(void)POSTMyReceiveShareListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYMyReceiveShareList params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///我发出的分享接口
+(void)POSTMySendShareListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYMySendShareList params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///查询集团下所有用户和分组名
+(void)POSTFindListUserByUserWithGroupParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYFindListUserByUserWithGroup params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///根据groupId查询改分组下所有用户
+(void)POSTFindListUserByGroupIdUserParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYFindListUserByGroupIdUser params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}
///app分享所属分组
+(void)POSTGroupTreesForShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure
{
    [[BYNetworkHelper sharedInstance] POST:BYGroupTreesForShare params:params success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } showError:YES];
    
}

@end
