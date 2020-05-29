//
//  BYNetworkHelper.m
//
//  Created by miwer on 16/8/4.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYNetworkHelper.h"
#import "BYSessionManager.h"
#import "BYProgressHUD.h"
#import "BYLoginViewController.h"
#import "EasyNavigation.h"
#import "NSDictionary+URL.h"
#import "NSDictionary+Merge.h"
#import "UIImage+BYSquareImage.h"
#import "BYAlertTip.h"
#import "BYLoginHttpTool.h"


static NSString * const BYAddRepairWork = @"api/appoint/order/repair";//新增检修单接口
static NSString * const BYAddRemoveWork = @"api/appoint/order/remove";//新增拆机单接口


static NSString * const BYEditRepairWork = @"api/appoint/order/repairEdit";//编辑检修单接口
static NSString * const BYEditRemoveWork = @"api/appoint/order/removeEdit";//编辑拆机单接口
static NSString * const BYRecognitionImg = @"api/technician/recognitionImgs";//车牌号/车架号识别

static NSString * const BYSendCode = @"user/sendCode";//获取验证码
@interface BYNetworkHelper ()

@property(nonatomic,strong) NSURLSessionTask * task;

@end

@implementation BYNetworkHelper

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static BYNetworkHelper * helper;
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

- (void)GET:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError{
    
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
    
    NSDictionary * mergeParams = [NSDictionary dictionary];
    
    if (![BYSaveTool isContainsKey:BYToken]) return;//如果没有存入过token(未成功登录),则直接返回
    NSDictionary * tokenParams = @{@"token" : [BYSaveTool valueForKey:BYToken]};
    
    if (params) {
        mergeParams = [tokenParams dictionaryByMergingWith:params];
    }else{
        mergeParams = tokenParams;
    }
    
    BYLog(@"params(%@) : %@",url,mergeParams);
    
    BYWeakSelf;
    self.task = [[BYSessionManager shareInstance] GET:url parameters:mergeParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (showHUD) {
            [BYProgressHUD dismiss];
        }
//        BYLog(@"%@",responseObject);
        if (responseObject) {
            
            [weakSelf successStatus:responseObject success:success failure:failure showError:showError];
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

///车牌 车架号识别
- (void)POSTCarNumerOrVin:(NSData *)data params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError{
    
    if (self.networkError == YES) {
        return BYShowError(@"网络错误");
    }
    if (showHUD) {
        [BYProgressHUD by_show];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@.do?token=%@",[BYSaveTool objectForKey:BYBaseUrl],BYRecognitionImg,[BYSaveTool objectForKey:BYToken]];
    BYLog(@"%@",params);
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
         [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        BYLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dict);
         [BYProgressHUD by_dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         BYLog(@"%@",error);
        failure(error);
         [BYProgressHUD by_dismiss];
    }];
}
///注册获取验证码
- (void)POSTSendCodeParams:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError{
    if (self.networkError == YES) {
        return BYShowError(@"网络错误");
    }
    if (showHUD) {
        [BYProgressHUD by_show];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@.do",[BYSaveTool objectForKey:BYBaseUrl],BYSendCode];
    BYLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         [BYProgressHUD by_dismiss];
        success(dict);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BYLog(@"%@",error);
        failure(error);
        [BYProgressHUD by_dismiss];
    }];
   
}

- (NSString *)saveImage:(UIImage *)image {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demodiao.jpg"]];  // 保存文件的名称
    BOOL result = [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
    //    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    
    if (result == YES) {
        NSLog(@"保存成功");
        return filePath;
    }
    return nil;
}

-(void)GETWXData:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure showHUD:(BOOL)showHUD showError:(BOOL)showError
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
    
//    NSDictionary * mergeParams = [NSDictionary dictionary];
//    
//    if (![BYSaveTool isContainsKey:BYToken]) return;//如果没有存入过token(未成功登录),则直接返回
//    NSDictionary * tokenParams = @{@"token" : [BYSaveTool valueForKey:BYToken]};
//    
//    if (params) {
//        mergeParams = [tokenParams dictionaryByMergingWith:params];
//    }else{
//        mergeParams = tokenParams;
//    }
    
    BYLog(@"params(%@) : %@",url,params);
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[BYSaveTool objectForKey:BYBaseUrl]]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    //    manager.requestSerializer.timeoutInterval = 5.0;
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = BYTimeoutInterval;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    BYWeakSelf;
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [BYProgressHUD by_dismiss];
        //        BYLog(@"%@",responseObject);
        if (responseObject) {
            
            [weakSelf successStatus:responseObject success:success failure:failure showError:showError];
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

- (void)POST:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id data))success failure:(void (^)(NSError *))failure showError:(BOOL)showError{
    
    if (self.networkError == YES) {
        return BYShowError(@"网络错误，请检查网络稍后再试！");
    }
    NSString * urlStr = nil;
//    if ([url isEqualToString:@"user/login"]) {
//        urlStr = [BYLoginUrl stringByAppendingString:url];
//    }else{
        urlStr = [[BYSaveTool objectForKey:BYBaseUrl] stringByAppendingString:url];
//    }
    
   
    
    NSDictionary * mergeParams = [NSDictionary dictionary];
    
//    if (![BYSaveTool isContainsKey:BYToken] && ![url isEqualToString:@"user/login"]&&![url isEqualToString:@"user/bindWeixin"] && ![url isEqualToString:@"user/queryWeixin"]&&![url isEqualToString:@"user/sendCode"]&&![url isEqualToString:@"user/sendCodeNum"] &&![url isEqualToString:@"user/registerUsers"]&&![url isEqualToString:@"user/resetPwd"]){
//          return;//如果没有存入过token(未成功登录),则直接返回
//    }
    
    
    
    if ([url isEqualToString:@"user/login"]||[url isEqualToString:@"user/bindWeixin"]||[url isEqualToString:@"user/queryWeixin"]||[url isEqualToString:@"user/sendCode"]||[url isEqualToString:@"user/sendCodeNum"]||[url isEqualToString:@"user/registerUsers"]||[url isEqualToString:@"user/resetPwd"]) {//如果是 注册获取验证码 登录或绑定微信请求,则不需要传入token参数
        mergeParams = params;
    }else if ([url isEqualToString:@"router"]){
//        urlStr = [@"http://umscollector.appleframework.com/" stringByAppendingString:url];
        urlStr = [BYSaveTool objectForKey:BYUmscollectorUrl];
        mergeParams = params;
    }else{
        if (![BYSaveTool valueForKey:BYToken]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYSaveTool setBool:NO forKey:BYLoginState];
//                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
//                loginVC.isLogout = YES;
//                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                //                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
                return ;
            });
        }else{
            NSDictionary * tokenParams = @{@"token" : [BYSaveTool valueForKey:BYToken]};
            if (params) {
                mergeParams = [tokenParams dictionaryByMergingWith:params];
            }else{
                mergeParams = tokenParams;
            }
        }
       
    }
    NSString *urlsss = nil;
    if ([url isEqualToString:@"router"]) {
        urlsss = urlStr;
    }else{
        urlsss = [urlStr stringByAppendingString:@".do"];
    }
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlsss]];
    request.HTTPMethod = @"POST";
    BYLog(@"%@",mergeParams);
    if ([url isEqualToString:BYAddRemoveWork] || [url isEqualToString:BYAddRepairWork] || [url isEqualToString:BYEditRepairWork] || [url isEqualToString:BYEditRemoveWork] || [url isEqualToString:@"api/quick/order/quickInstall"] || [url isEqualToString:@"api/quick/order/quickRemove"] || [url isEqualToString:@"api/quick/order/quickRepair"]) {
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:mergeParams options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:[BYSaveTool valueForKey:BYToken] forHTTPHeaderField:@"token"];
        request.HTTPBody = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        request.HTTPBody = [[mergeParams URLQueryString] dataUsingEncoding:NSUTF8StringEncoding];
    }

    request.timeoutInterval = BYTimeoutInterval;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (showError) {
        [BYProgressHUD by_show];
    }
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    BYWeakSelf;
    self.task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (showError) {
            [BYProgressHUD by_dismiss];
        }
        if (error) {
            if (showError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYShowError(@"请求失败，请检查网络稍后再试！");
                });
            }
            
            if (failure) {
                failure(error);
            }
            BYLog(@"%@",error);
            return ;
        }
        
        if (data) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            BYLog(@"dict=%@",dict);
            if ([url isEqualToString:@"user/login"] && [dict[@"code"] integerValue] == -1) {//如果登录页面的请求返回-1,则不让登录
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return BYShowError(dict[@"msg"]);
            }
            if ([url isEqualToString:@"user/bindMobile"]&& [dict[@"code"] integerValue] == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                return BYShowError(dict[@"msg"]);
            }
            if ([url isEqualToString:@"router"]){
                NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
                deviceDict[@"code"] = @"10000000";
                deviceDict[@"data"] = dict;
                [weakSelf successStatus:deviceDict success:success failure:failure showError:showError];
            }else{
                [weakSelf successStatus:dict success:success failure:failure showError:showError];
            }
            
        }
        
    }];

    [self.task resume];
}

- (void)POSTUploadImage:(NSString *)url params:(NSMutableDictionary *)params images:(NSMutableArray *)images success:(void(^)(id data))success{
    
    if (self.networkError == YES) {
        return BYShowError(@"网络错误，请检查网络稍后再试！");
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [BYProgressHUD by_showBgViewWithStatus:@"安装信息上传中..."];
    
    params[@"token"] = [BYSaveTool valueForKey:BYToken];

    BYLog(@"mergeParams : %@",params);
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[BYSaveTool objectForKey:BYBaseUrl]]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
//    manager.requestSerializer.timeoutInterval = 5.0;
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = BYTimeoutInterval;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(images.firstObject, 0.5) name:@"deviceCarNumImg" fileName:@"image.png" mimeType:@"image/png"];
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(images[1], 0.5) name:@"connectionIntallImg" fileName:@"image.png" mimeType:@"image/png"];
        
        //上传多张图片
        NSArray * imageNames = @[@"imgA",@"imgB",@"imgC",@"imgD"];
        for(NSInteger i = 2; i < images.count; i++){
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 0.5) name:imageNames[i - 2] fileName:@"image.png" mimeType:@"image/png"];
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        BYLog(@"%@",responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [BYProgressHUD dismiss];
        if (responseObject) {
            
            [self successStatus:responseObject success:success failure:nil showError:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [BYProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showErrorWithStatus:@"上传失败"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (error) {
            BYLog(@"%@",error);
        }
    }];
    
}

-(void)POSTUploadsingleImageUrl:(NSString *)url params:(NSMutableDictionary *)params image:(UIImage *)image success:(void (^)(id))success
{
    if (self.networkError == YES) {
        return BYShowError(@"网络错误");
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
    
    params[@"token"] = [BYSaveTool valueForKey:BYToken];
    
    BYLog(@"mergeParams : %@",params);
    NSString *urlStr = [NSString stringWithFormat:@"%@?token=%@",url,[BYSaveTool valueForKey:BYToken]];
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[BYSaveTool objectForKey:BYBaseUrl]]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    //    manager.requestSerializer.timeoutInterval = 5.0;
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = BYTimeoutInterval;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    image = [UIImage scaleImage:image toKb:100];
    image = [UIImage image:image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
//        [formData appendPartWithFormData:UIImageJPEGRepresentation(image, 0.5) name:@"image"];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"image.png" mimeType:@"image/png"];
        
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(images[1], 0.5) name:@"connectionIntallImg" fileName:@"image.png" mimeType:@"image/png"];
        
//        //上传多张图片
//        NSArray * imageNames = @[@"imgA",@"imgB",@"imgC",@"imgD"];
//        for(NSInteger i = 2; i < images.count; i++){
//            
//            [formData appendPartWithFileData:UIImageJPEGRepresentation(images[i], 0.5) name:imageNames[i - 2] fileName:@"image.png" mimeType:@"image/png"];
//        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        BYLog(@"%@",responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (responseObject) {
            
            [self successStatus:responseObject success:success failure:nil showError:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYProgressHUD by_showErrorWithStatus:@"上传失败"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (error) {
            BYLog(@"%@",error);
        }
    }];

}
///寻址接口
-(void)POSTRouteUrlWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure showError:(BOOL)showError
{
    if (self.networkError == YES) {
        return BYShowError(@"网络错误");
    }
    NSMutableURLRequest *request;
    //实现手动切换环境url
    NSString *handSetRouteUrl = [BYSaveTool objectForKey:BYHandSetRouteUrl];
    if (!handSetRouteUrl) {//正式环境
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BYNewRouteUrl]];
    }else if([handSetRouteUrl isEqualToString:@"dev"]){//开发环境
        
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=%@&method=by.router.api.server&env=reb",BYAppCode]]];
    }else if ([handSetRouteUrl isEqualToString:@"test"]){//测试环境
        
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=%@&method=by.router.api.server&env=test",BYAppCode]]];
    }else if([handSetRouteUrl isEqualToString:@"demo"]){//预发布环境
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=%@&method=by.router.api.server&env=demo",BYAppCode]]];
    }else if([handSetRouteUrl isEqualToString:@"release"]){//正式环境
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://router.appleframework.com/router?format=json&appkey=yunchedaian&v=1.0&ver=%@&method=by.router.api.server&env=release",BYAppCode]]];
    }else{
         request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BYNewRouteUrl]];
    }
   
    
    request.HTTPMethod = @"POST";
    
    request.timeoutInterval = BYTimeoutInterval;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (showError) {
        [BYProgressHUD by_show];
    }
    
    NSURLSession * session = [NSURLSession sharedSession];
    //    BYWeakSelf;
    self.task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (showError) {
            [BYProgressHUD by_dismiss];
        }
        if (error) {
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                BYShowError(@"请求失败，请检查网络稍后再试！");
//            });
            if (failure) {
                failure(error);
            }
            BYLog(@"%@",error);
            return ;
        }
        
        if (data) {
            
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if (success) {
                success(dict);
            }
        }
        
    }];
    
    [self.task resume];
}

-(void)successStatus:(NSDictionary *)dict success:(void(^)(id data))success failure:(void (^)(NSError *))failure showError:(BOOL)showError{
    BYLog(@"dict= %@",dict);
    switch ([dict[@"code"] integerValue]) {
        case 10000000:{//登录成功
            
//            if (!showError) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [BYProgressHUD by_dismiss];
//                });
//            }
            
            if (success) {
                success(dict[@"data"]);
            }
            
        }
            break;
        case 1000:{//登录成功
            if (success) {
                success(dict[@"data"]);
            }
            
        }
            break;
        case -5:{//登录失败
            
            dispatch_async(dispatch_get_main_queue(), ^{

                BYShowError(dict[@"msg"]);
//                showError ? BYShowError(dict[@"msg"]) : [BYProgressHUD by_dismiss];//为真则显示错误提示,不为真则不显示错误提示
            });
        }
            break;
            
        case -8:{//被挤出登录
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                
                [BYSaveTool setBool:NO forKey:BYLoginState];
              
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                loginVC.isLogout = YES;
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                navi.modalPresentationStyle = UIModalPresentationFullScreen;
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BYShowError(@"账号过期,请重新登录");
                });
                  [BYSaveTool removeObjectForKey:BYToken];
            });
        }
            break;
            
        case -1:{
            [BYSaveTool setBool:NO forKey:BYLoginState];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BYWeakSelf;
                NSString *username = [BYSaveTool objectForKey:BYusername];
                NSString *password = [BYSaveTool objectForKey:BYpassword];
                if (username.length && password.length) {
                    [BYLoginHttpTool PostLogin:username password:password sourceFlag:1 Success:^(id data) {
                        [BYSaveTool setBool:YES forKey:BYLoginState];
                        
                    } showError:NO];
                }
              
            });
        }
            break;
            
//        case -2:{
//            if (success) {
//                success(dict[@"data"]);
//            }
//        }
//            break;
            
        case 10000007:{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYShowError(@"Token非法");
                [BYSaveTool setBool:NO forKey:BYLoginState];
                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                loginVC.isLogout = YES;
                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                navi.modalPresentationStyle = UIModalPresentationFullScreen;
                [UIApplication sharedApplication].keyWindow.rootViewController = navi;
            });
        }
            break;
        
        case -7:{
            dispatch_async(dispatch_get_main_queue(), ^{
                
//                BYShowError(dict[@"msg"]);
//                [BYSaveTool setBool:NO forKey:BYLoginState];
//                 [BYSaveTool removeObjectForKey:BYToken];
//                BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
//                loginVC.isLogout = YES;
//                EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];
//                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
            });
        }
            break;
        case -10:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"verLowsNotifi" object:self userInfo:@{@"goToUrl": dict[@"msg"]}];
            });
            
            
        }
            break;
            
        case 12000006:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYSaveTool setBool:NO forKey:BYLoginState];
                if ([NSStringFromClass([self xs_getCurrentViewController].class) isEqualToString:@"BYLoginViewController"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BYShowError(dict[@"msg"]);
                        
                        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:500 userInfo:nil];
                        if (failure) {
                            failure(error);
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [BYSaveTool setBool:NO forKey:BYLoginState];
                        BYShowError(dict[@"msg"]);
                        BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                        loginVC.isLogout = YES;
                        EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                        navi.modalPresentationStyle = UIModalPresentationFullScreen;
                        [UIApplication sharedApplication].keyWindow.rootViewController = navi;
                    });
                }
            });
            
           

        }
            break;
        case 12000007:{
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [BYSaveTool setBool:NO forKey:BYLoginState];
            if ([NSStringFromClass([self xs_getCurrentViewController].class) isEqualToString:@"BYLoginViewController"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYShowError(dict[@"msg"]);
                    
                    NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:500 userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYSaveTool setBool:NO forKey:BYLoginState];
                    BYShowError(dict[@"msg"]);
                    BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                    loginVC.isLogout = YES;
                    EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                    navi.modalPresentationStyle = UIModalPresentationFullScreen;
                    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
                });
            }
                   });
        }
            break;
        case 12000008:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYSaveTool setBool:NO forKey:BYLoginState];
            if ([NSStringFromClass([self xs_getCurrentViewController].class) isEqualToString:@"BYLoginViewController"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYShowError(dict[@"msg"]);
                    
                    NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:500 userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYSaveTool setBool:NO forKey:BYLoginState];
                    BYShowError(dict[@"msg"]);
                    BYLoginViewController * loginVC = [[BYLoginViewController alloc] init];
                    loginVC.isLogout = YES;
                    EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

                    navi.modalPresentationStyle = UIModalPresentationFullScreen;
                    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
                });
            }
                 });
        }
            break;
            
            
        default:
            dispatch_async(dispatch_get_main_queue(), ^{
                BYShowError(dict[@"msg"]);
                
                NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:500 userInfo:nil];
                if (failure) {
                    failure(error);
                }
            });
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
                [BYNetworkHelper sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                BYLog(@"没有网络");
                [BYNetworkHelper sharedInstance].networkError = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(NO)}];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                BYLog(@"手机自带网络");
                [BYNetworkHelper sharedInstance].networkError = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(YES)}];

                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                BYLog(@"WIFI");
                [BYNetworkHelper sharedInstance].networkError = NO;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BYNetStatusNotificationKey object:nil userInfo:@{@"isNet" : @(YES)}];

                break;
        }
    }];
    [netManager startMonitoring];
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

-(BOOL)currentVcIsLoginVc{
    
    if ([[self topVcWithRootVc:[UIApplication sharedApplication].keyWindow.rootViewController] isKindOfClass:[BYLoginViewController class]]) {
        
        BYLoginViewController * wrapVc = (BYLoginViewController *)[self topVcWithRootVc:[UIApplication sharedApplication].keyWindow.rootViewController];
        return [wrapVc isKindOfClass:NSClassFromString(@"BYLoginViewController")];
    }
    
    return NO;
}



- (UIViewController *)xs_getCurrentViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    
    //获取根控制器
    UIViewController* currentViewController = window.rootViewController;
    //获取当前页面控制器
    BOOL runLoopFind = YES;

    while (runLoopFind){
    

        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]){
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}




#pragma mark - lazy
-(NSMutableArray *)taskArr{
    if (_taskArr == nil) {
        _taskArr = [[NSMutableArray alloc] init];
    }
    return _taskArr;
}




@end
