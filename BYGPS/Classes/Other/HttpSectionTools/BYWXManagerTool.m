//
//  BYWXManagerTool.m
//  BYGPS
//
//  Created by ZPD on 2017/6/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYWXManagerTool.h"
#import "BYSessionManager.h"
#import "BYProgressHUD.h"
#import "BYLoginViewController.h"
#import "EasyNavigation.h"
#import "BYNetworkHelper.h"

#import "NSDictionary+URL.h"
#import "NSDictionary+Merge.h"

static NSString *queryWeixinUrl = @"user/queryWeixin";

@interface BYWXManagerTool ()

@property(nonatomic,strong) NSURLSessionTask * task;

@end

@implementation BYWXManagerTool

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static BYWXManagerTool * helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [super allocWithZone:zone];
        helper.manager = [BYSessionManager shareInstance];
    });
    return helper;
}

+ (instancetype)sharedInstance{
    return [[super alloc] init];
}


//获取微信AccessToken
-(void)GetWXAccessTokenWithCode:(NSString *)code success:(void (^)(id))success failure:(void (^)(NSError *))failure showHUD:(BOOL)showHUD showError:(BOOL)showError
{
    
    if (self.networkError == YES) {
        if (failure) {
            failure(nil);
        }
        return BYShowError(@"网络错误");
    }
    //如果需要展示菊花,反正状态栏上面的菊花是肯定要转
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (showHUD) {
        [BYProgressHUD by_show];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",BYWXAppId,BYWXAppSecret,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_dismiss];
        });
        if (responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dic);
//            [self successStatus:dic success:success showError:showError];
        }
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        //        NSString* accessToken=dic[@"access_token"];
        //        NSString* openID=dic[@"openid"];
        //        [self requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            BYShowError(@"加载失败");
        });
        if (error) {
            
            if (failure) {
                failure(error);
            }
            
            BYLog(@"%@",error);
        }
        
    }];
    
}
+(void)PostQueryWeixinWithWeixin:(NSString *)weixin Success:(void (^)(id data))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"weixin"] = weixin;
    
    [[BYNetworkHelper sharedInstance] POST:queryWeixinUrl params:params success:^(id data) {
        
        [BYProgressHUD by_dismiss];
        if (success) {
            success(data);
        }
        
    } failure:nil showError:YES];
}

- (void)GETQueryWeixin:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure showHUD:(BOOL)showHUD showError:(BOOL)showError
{
    
    
    if (self.networkError == YES) { 
        if (failure) {
            failure(nil);
        }
        return BYShowError(@"网络错误");
    }
    
    //如果需要展示菊花,反正状态栏上面的菊花是肯定要转
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (showHUD) {
        [BYProgressHUD by_show];
    }
    
    BYWeakSelf;
    self.task = [[BYSessionManager shareInstance] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [BYProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_dismiss];
        });
                BYLog(@"%@",responseObject);
        if (responseObject) {
            
            [weakSelf successStatus:responseObject success:success showError:showError];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            BYShowError(@"加载失败");
        });
        
        if (error) {
            
            if (failure) {
                failure(error);
            }
            
            BYLog(@"%@",error);
        }
        
    }];

}

-(void)successStatus:(NSDictionary *)dict success:(void(^)(id data))success showError:(BOOL)showError{
    
    switch ([dict[@"code"] integerValue]) {
        case 10000000:{//登录成功
            
            if (!showError) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYProgressHUD by_dismiss];
                });
            }
            
            if (success) {
                success(dict[@"data"]);
            }
            
        }
            break;
        case -5:{//登录失败
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                showError ? BYShowError(dict[@"msg"]) : [BYProgressHUD by_dismiss];//为真则显示错误提示,不为真则不显示错误提示
            });
        }
            break;
            
        case -8:{//被挤出登录
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYShowError(@"账号过期,请重新登录");
                [BYSaveTool setBool:NO forKey:BYLoginState];
                [BYSaveTool removeObjectForKey:BYToken];
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                loginVC.isLogout = YES;
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
            });
        }
            break;
            
        case -1:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                //                loginVC.isLogout = YES;
                //                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                //                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:^{
                 [BYSaveTool setBool:NO forKey:BYLoginState];
               
                BYShowError(dict[@"msg"]);
                //                }];
            });
        }
            
        case 7:{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYShowError(@"缺少token参数");
                
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                loginVC.isLogout = YES;
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
            });
        }
            
        case 10000007:{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYShowError(@"Token非法");
                
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                loginVC.isLogout = YES;
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                navi.modalPresentationStyle = UIModalPresentationFullScreen;
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
            });
        }
        default:
            BYShowError(dict[@"msg"]);
            break;
            
    }
    
}

+ (void)startMonitoring{
    AFNetworkReachabilityManager * netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                BYLog(@"未知网络");
                [BYWXManagerTool sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                BYLog(@"没有网络");
                [BYWXManagerTool sharedInstance].networkError = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(NO)}];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                BYLog(@"手机自带网络");
                [BYWXManagerTool sharedInstance].networkError = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(YES)}];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                BYLog(@"WIFI");
                [BYWXManagerTool sharedInstance].networkError = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(YES)}];
                
                break;
        }
    }];
    [netManager startMonitoring];
}

#pragma mark - lazy
-(NSMutableArray *)taskArr{
    if (_taskArr == nil) {
        _taskArr = [[NSMutableArray alloc] init];
    }
    return _taskArr;
}


@end
