//
//  BYNetworkHelper.h
//
//  Created by miwer on 16/8/4.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYSessionManager;

@interface BYNetworkHelper : NSObject

@property(nonatomic,assign) BOOL networkError;

@property(nonatomic,strong) NSMutableArray * taskArr;//网络请求任务数组

@property(nonatomic,strong) BYSessionManager * manager;

+ (instancetype)sharedInstance;

+ (void)startMonitoring;

//- (void)GET:(NSString *)url params:(NSDictionary *)params success:(void(^)(id data))success isShowFlower:(BOOL)isShowFlower;//只有菊花,没有转圈

- (void)GET:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;//showError为NO时表示自己处理progressHUD的消失,主要是为了给用户特殊提示

- (void)POST:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showError:(BOOL)showError;

- (void)POSTUploadImage:(NSString *)url params:(NSMutableDictionary *)params images:(NSMutableArray *)images success:(void(^)(id data))success;

-(void)POSTUploadsingleImageUrl:(NSString *)url params:(NSMutableDictionary *)params image:(UIImage *)image success:(void(^)(id data))success ;

- (void)GETWXData:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;//showError为NO时表示自己处理progressHUD的消失,主要是为了给用户特殊提示
///车牌 车架号识别
- (void)POSTCarNumerOrVin:(NSData *)image params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;
///寻址接口
-(void)POSTRouteUrlWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure showError:(BOOL)showError;
///注册获取验证码
- (void)POSTSendCodeParams:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;
@end
