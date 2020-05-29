//
//  BYWXManagerTool.h
//  BYGPS
//
//  Created by ZPD on 2017/6/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYSessionManager;

@interface BYWXManagerTool : NSObject

@property(nonatomic,assign) BOOL networkError;

@property(nonatomic,strong) NSMutableArray * taskArr;//网络请求任务数组

@property(nonatomic,strong) BYSessionManager * manager;

+ (instancetype)sharedInstance;

+ (void)startMonitoring;

-(void)GetWXAccessTokenWithCode:(NSString *)code success:(void(^)(id data))success failure:(void(^)(NSError *error))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;

+(void)PostQueryWeixinWithWeixin:(NSString *)weixin Success:(void (^)(id))success;

- (void)GETQueryWeixin:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure showHUD:(BOOL)showHUD showError:(BOOL)showError;

@end
