//
//  BYQueryZoneHttpTool.h
//  BYGPS
//
//  Created by ZPD on 2017/8/15.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYQueryZoneHttpTool : NSObject

+(void)POSTQueryZoneSuccess:(void (^)(NSArray * data))success failure:(void(^)(NSError *error))failure;

@end
