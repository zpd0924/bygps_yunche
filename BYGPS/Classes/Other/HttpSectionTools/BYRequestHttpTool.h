//
//  BYRequestHttpTool.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/25.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BYRequestHttpTool : NSObject
///发送验证码
+(void)POSTSendCodeParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///验证发送验证码次数
+(void)POSTSendCodeNumberParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///注册
+(void)POSTRegisterUsersParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///忘记密码

+(void)POSTResetPwdParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///结束分享
+(void)POSTEndShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///编辑分享
+(void)POSTUpdateShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///保存分享
+(void)POSTSaveShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///分享查询已安装设备接口
+(void)POSTShareCarDeviceParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///我收到分享的车辆数量和未读数量
+(void)POSTMyReceiveShareCountParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///我发出分享的车辆数量和未读数量
+(void)POSTMySendShareCountParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///我收到的分享接口
+(void)POSTMyReceiveShareListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///我发出的分享接口
+(void)POSTMySendShareListParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///查询集团下所有用户和分组名
+(void)POSTFindListUserByUserWithGroupParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///根据groupId查询改分组下所有用户
+(void)POSTFindListUserByGroupIdUserParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
///app分享所属分组
+(void)POSTGroupTreesForShareParams:(NSMutableDictionary *)params success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;
@end
