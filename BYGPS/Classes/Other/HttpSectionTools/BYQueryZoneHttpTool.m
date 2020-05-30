//
//  BYQueryZoneHttpTool.m
//  BYGPS
//
//  Created by ZPD on 2017/8/15.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYQueryZoneHttpTool.h"
#import "BYNetworkHelper.h"

static NSString * const queryZoneUrl = @"zone/listDangerArea";

@implementation BYQueryZoneHttpTool

+(void)POSTQueryZoneSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [[BYNetworkHelper sharedInstance] POST:queryZoneUrl params:nil success:^(NSArray * data) {
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
