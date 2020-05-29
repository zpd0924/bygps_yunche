//
//  BYSessionManager.h
//
//  Created by miwer on 16/8/3.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface BYSessionManager : AFHTTPSessionManager

+ (instancetype)shareInstance;

@end
