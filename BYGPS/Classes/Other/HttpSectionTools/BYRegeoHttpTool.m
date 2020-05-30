//
//  BYRegeoHttpTool.m
//  BYGPS
//
//  Created by ZPD on 2017/6/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYRegeoHttpTool.h"
#import "BYNetworkHelper.h"


static NSString * const regeoUrl = @"now/queryAddress";
@implementation BYRegeoHttpTool


+(void)POSTRegeoAddressWithLat:(CGFloat)lat lng:(CGFloat)lng success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lat"] = @(lat);
    params[@"lon"] = @(lng);
    
    [[BYNetworkHelper sharedInstance] POST:regeoUrl params:params success:^(id data) {
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
