//
//  BYLoginHttpTool.h
//  BYGPS
//
//  Created by miwer on 16/8/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYLoginHttpTool : NSObject

+(void)PostLogin:(NSString *)username password:(NSString *)password sourceFlag:(NSInteger )sourceFlag Success:(void(^)(id data))success showError:(BOOL)showError;//2.6.5登录
+(void)POSTLogoutSuccess:(void (^)(id data))success;//注销

+(void)POSTUpdatePasswordWithOld:(NSString *)old now:(NSString *)now success:(void (^)())success;//修改密码

+(void)PostBindMobileWithMobile:(NSString *)mobile code:(NSString *)code Success:(void(^)(id data))success;//绑定手机号

+(void)PostBindWeiXinWithLoginname:(NSString *)loginname weixinOpenId:(NSString *)weixinOpenId password:(NSString *)password Success:(void(^)(id data))success;//绑定微信号

+(void)POSTMessageCodeWithMobile:(NSString *)mobile success:(void (^)(id data))success failure:(void(^)(NSError *error))failure;//短信验证码
//解绑手机号
+(void)POSTUnbindMobileSuccess:(void (^)(id data))success;

////获取微信AccessToken
//+(void)GetWXAccessTokenWithCode:(NSString *)code grant_type:(NSString *)grant_type success:(void (^)(id data))success failure:(void(^)(NSError *error))failure;
//版本更新
+(void)POSTUpdateWithUserNameSuccess:(void (^)(id))success;
@end
